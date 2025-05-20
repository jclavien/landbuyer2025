defmodule Landbuyer2025.Strategies.StrategySnapshot do
  use Ecto.Schema
  import Ecto.Changeset

  schema "strategy_snapshots" do
    field :strategy_display_id, :string
    field :strategy_name, :string
    field :interval, :integer
    field :currency_pair, :string
    field :decimals, :integer
    field :take_profit, :float
    field :stop_loss, :float
    field :distance, :float
    field :order_size, :float
    field :max_orders, :integer
    field :direction, :string
    field :status, :string

    belongs_to :strategy, Landbuyer2025.Strategies.Strategy

    timestamps()
  end

  def changeset(snapshot, attrs) do
    snapshot
    |> cast(attrs, [
      :strategy_id,
      :strategy_display_id,
      :strategy_name,
      :interval,
      :currency_pair,
      :decimals,
      :take_profit,
      :stop_loss,
      :distance,
      :order_size,
      :max_orders,
      :direction,
      :status
    ])
    |> validate_required([
      :strategy_id,
      :strategy_display_id,
      :strategy_name,
      :interval,
      :currency_pair,
      :decimals,
      :take_profit,
      :stop_loss,
      :distance,
      :order_size,
      :max_orders,
      :direction,
      :status
    ])
  end
end
