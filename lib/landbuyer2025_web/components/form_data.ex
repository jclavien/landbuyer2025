defmodule Landbuyer2025Web.FormData do
  defmodule Account do
    defstruct [
      account_name: "",
      id_oanda: "",
      service: "",
      token: "",
      account_name_error: nil,
      id_oanda_error: nil,
      service_error: nil,
      token_error: nil
    ]
  end

  defmodule Strategy do
    defstruct [
      strategy: "",
      interval: "",
      currency_pair: "",
      decimals: "",
      take_profit: "",
      stop_loss: "",
      distance: "",
      size: "",
      max_orders: "",
      strategy_error: nil,
      interval_error: nil,
      currency_pair_error: nil,
      decimals_error: nil,
      take_profit_error: nil,
      stop_loss_error: nil,
      distance_error: nil,
      size_error: nil,
      max_orders_error: nil
    ]
  end
end
