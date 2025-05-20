defmodule Landbuyer2025.Strategies.LandbuyerV3 do
  @moduledoc """
  Landbuyer v3.0 strategy.

  Amélioré pour :
  - Espacement d'ordres fixe en grille
  - Placement basé sur TP existants
  - Support LONG / SHORT via paramètre `direction`
  - Amorçage intelligent en l'absence de positions / ordres
  - Reprise de la grille si le marché décroche au-delà d'un seuil, tout en respectant l'alignement de grille
  """

  # @behaviour Landbuyer2025.Strategie

  alias Landbuyer2025.Accounts.Account
  alias Landbuyer2025.Strategies.Strategy

  defp decrypted_token(account) do
    Landbuyer2025.Encryption.decrypt(account.token)
  end

  @spec key() :: atom()
  def key, do: :landbuyer_v3

  @spec name() :: String.t()
  def name, do: "Landbuyer v3.0"

  @spec run(Account.t(), Strategy.t()) :: Landbuyer2025.Strategies.events()
  def run(account, strategy) do
    with {:ok, market_price} <- get_market_price(account, strategy),
         {:ok, mit_orders, tp_orders} <- get_orders(account, strategy),
         {:ok, orders_to_place} <- compute_orders(market_price, mit_orders, tp_orders, strategy) do
      post_orders(orders_to_place, account, strategy)
    end
  end

  defp get_market_price(account, strategy) do
    baseurl = "https://#{account.hostname}/v3/accounts/#{account.id_oanda}"

    url = "#{baseurl}/pricing?instruments=#{strategy.currency_pair}"
    headers = [{"Authorization", "Bearer #{decrypted_token(account)}"}]
    options = [timeout: strategy.interval]

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           HTTPoison.get(url, headers, options),
         {:ok, %{"prices" => prices}} <- Poison.decode(body) do
      %{"closeoutBid" => bid, "closeoutAsk" => ask} = hd(prices)
      median = (String.to_float(bid) + String.to_float(ask)) / 2
      {:ok, Float.round(median, strategy.decimals)}
    else
      poison_error -> [handle_poison_error(poison_error)]
    end
  end

  defp get_orders(account, strategy) do
    baseurl = "https://#{account.hostname}/v3/accounts/#{account.id_oanda}"

    url = "#{baseurl}/orders?state=PENDING&instrument=#{strategy.currency_pair}&count=500"
    headers = [{"Authorization", "Bearer #{decrypted_token(account)}"}]
    options = [timeout: strategy.interval]

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           HTTPoison.get(url, headers, options),
         {:ok, %{"orders" => orders}} <- Poison.decode(body) do
      mit_orders =
        orders
        |> Enum.filter(fn %{"type" => type} -> type == "MARKET_IF_TOUCHED" end)
        |> Enum.map(fn %{"price" => price} -> String.to_float(price) end)

      tp_orders =
        orders
        |> Enum.filter(fn %{"type" => type} -> type == "TAKE_PROFIT" end)
        |> Enum.map(fn %{"price" => price} -> String.to_float(price) end)

      {:ok, mit_orders, tp_orders}
    else
      poison_error -> [handle_poison_error(poison_error)]
    end
  end

  defp compute_orders(market_price, mit_orders, tp_orders, strategy) do
    price_divider = :math.pow(10, strategy.decimals)
    tp_distance = strategy.take_profit / price_divider
    step_size = strategy.distance / price_divider
    decimal = strategy.decimals
    direction = strategy.direction

    cond do
      mit_orders == [] and tp_orders == [] ->
        rounded = Float.ceil(market_price * price_divider) / price_divider
        range = -10..10

        orders =
          Enum.map(range, fn i ->
            i = if direction == "SHORT", do: -i, else: i
            price = Float.round(rounded + i * step_size, decimal)
            tp_price = Float.round(price + tp_distance, decimal)

            %{
              type: "MARKET_IF_TOUCHED",
              instrument: strategy.currency_pair,
              units: strategy.order_size,
              price: Float.to_string(price),
              timeInForce: "GFD",
              takeProfitOnFill: %{
                timeInForce: "GTC",
                price: Float.to_string(tp_price)
              }
            }
          end)

        {:ok, orders}

      tp_orders != [] ->
        last_tp = Enum.max(tp_orders)
        last_base = Float.round(last_tp - tp_distance, decimal)
        current_base = Float.round(market_price, decimal)

        if current_base < last_base - tp_distance do
          rounded = Float.ceil(market_price * price_divider) / price_divider
          offset = rem(round((last_tp - tp_distance - rounded) / step_size), 1)
          aligned = Float.round(rounded + offset * step_size, decimal)

          range = -10..10

          orders =
            Enum.map(range, fn i ->
              i = if direction == "SHORT", do: -i, else: i
              price = Float.round(aligned + i * step_size, decimal)
              tp_price = Float.round(price + tp_distance, decimal)

              if price not in mit_orders do
                %{
                  type: "MARKET_IF_TOUCHED",
                  instrument: strategy.currency_pair,
                  units: strategy.order_size,
                  price: Float.to_string(price),
                  timeInForce: "GFD",
                  takeProfitOnFill: %{
                    timeInForce: "GTC",
                    price: Float.to_string(tp_price)
                  }
                }
              end
            end)
            |> Enum.reject(&is_nil/1)

          {:ok, orders}
        else
          new_levels =
            for i <- 1..strategy.max_orders do
              Float.round(last_base - i * step_size, decimal)
            end

          mit_prices = Enum.map(mit_orders, &Float.round(&1, decimal))
          levels_to_place = Enum.reject(new_levels, fn lvl -> lvl in mit_prices end)

          orders =
            Enum.map(levels_to_place, fn entry_price ->
              tp_price = Float.round(entry_price + tp_distance, decimal)

              %{
                type: "MARKET_IF_TOUCHED",
                instrument: strategy.currency_pair,
                units: strategy.order_size,
                price: Float.to_string(entry_price),
                timeInForce: "GFD",
                takeProfitOnFill: %{
                  timeInForce: "GTC",
                  price: Float.to_string(tp_price)
                }
              }
            end)

          {:ok, orders}
        end

      true ->
        [{:nothing, :waiting_for_first_executed_order, %{}}]
    end
  end

  defp post_orders([], _account, _strategy), do: [{:nothing, :no_orders_to_place, %{}}]

  defp post_orders(orders, account, strategy) do
    opts = [timeout: strategy.interval, on_timeout: :kill_task, zip_input_on_exit: true]

    orders
    |> Task.async_stream(&post_order(&1, account, strategy), opts)
    |> Enum.map(fn
      {:ok, response} -> response
      {:exit, {{:ok, _response}, reason}} -> {:error, :task_error, %{reason: reason}}
    end)
  end

  defp post_order(order, account, strategy) do
    request = %HTTPoison.Request{
      method: :post,
      url: "https://#{account.hostname}/v3/accounts/#{account.id_oanda}/orders",
      headers: [
        {"Authorization", "Bearer #{decrypted_token(account)}"},
        {"Content-Type", "application/json"}
      ],
      options: [timeout: strategy.interval],
      body: Poison.encode!(%{"order" => order})
    }

    case HTTPoison.request(request) do
      {:ok, %HTTPoison.Response{status_code: 201, headers: headers}} ->
        {_, request_id} = Enum.find(headers, fn {key, _val} -> key == "RequestID" end)

        {:success, :order_placed,
         %{request_id: String.to_integer(request_id), price: order.price}}

      poison_error ->
        handle_poison_error(poison_error)
    end
  end

  defp handle_poison_error(poison_error) do
    case poison_error do
      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, :wrong_http_code, %{status_code: code}}

      {:ok, %HTTPoison.Response{} = res} ->
        {:error, :bad_http_response, Map.from_struct(res)}

      {:error, err} ->
        {:error, :poison_error, Map.from_struct(err)}
    end
  end
end
