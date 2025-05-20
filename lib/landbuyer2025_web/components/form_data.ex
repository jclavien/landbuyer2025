defmodule Landbuyer2025Web.FormData do
  defmodule Account do
    defstruct account_name: "",
              id_oanda: "",
              service: "",
              token: "",
              account_name_error: nil,
              id_oanda_error: nil,
              service_error: nil,
              token_error: nil
  end

  defmodule Strategy do
    defstruct account_id: nil,
              strategy_name: "",
              interval: "",
              currency_pair: "",
              decimals: "",
              take_profit: "",
              stop_loss: "",
              distance: "",
              order_size: "",
              max_orders: "",
              direction: "",
              strategy_name_error: nil,
              interval_error: nil,
              currency_pair_error: nil,
              decimals_error: nil,
              take_profit_error: nil,
              stop_loss_error: nil,
              distance_error: nil,
              order_size_error: nil,
              max_orders_error: nil,
              direction_error: nil

    def from_strategy(strategy) do
      %__MODULE__{
        account_id: strategy.account_id,
        strategy_name: strategy.strategy_name,
        interval: to_string(strategy.interval),
        currency_pair: strategy.currency_pair,
        decimals: to_string(strategy.decimals),
        take_profit: to_string(strategy.take_profit),
        stop_loss: to_string(strategy.stop_loss),
        distance: to_string(strategy.distance),
        order_size: to_string(strategy.order_size),
        max_orders: to_string(strategy.max_orders),
        direction: strategy.direction
      }
    end
  end
end
