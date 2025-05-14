defmodule Landbuyer2025.Strategies.Empty do
  @moduledoc """
  Empty strategy.

  This strategy does nothing and may be used as a template for new strategies or as a test strategy
  for gen_server and supervisor behaviours.
  """

  #  @behaviour Landbuyer2025.Strategies

  alias Landbuyer2025.Accounts.Account

  @spec key() :: atom()
  def key, do: :empty

  @spec name() :: String.t()
  def name, do: "Select"

  @spec run(Account.t(), Trader.t()) :: Strategies.events()
  def run(_account, _trader) do
    [{:nothing, :empty_strategy, %{}}]
  end
end
