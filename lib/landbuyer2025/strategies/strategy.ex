defmodule Landbuyer2025.Strategies.Strategy do
  use Ecto.Schema
  import Ecto.Changeset

  schema "strategies" do
    field :strategy_display_id, :string
    field :strategy_name, :string
    field :account_id, :id
    field :interval, :integer
    field :currency_pair, :string
    field :decimals, :integer
    field :take_profit, :float
    field :stop_loss, :float
    field :distance, :float
    field :order_size, :float
    field :max_orders, :integer
    field :direction, :string
    field :status, :string, default: "stopped"

    timestamps()
  end

  @doc false
  def changeset(strategy, attrs) do
    strategy
    |> cast(attrs, [
      :strategy_display_id,
      :strategy_name,
      :account_id,
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
      :strategy_display_id,
      :strategy_name,
      :account_id,
      :interval,
      :currency_pair,
      :decimals,
      :take_profit,
      :stop_loss,
      :distance,
      :order_size,
      :max_orders,
      :direction
    ])
    |> validate_inclusion(:direction, ["LONG", "SHORT"])
    |> unique_constraint(:account_id, name: :unique_strategy_per_account)
  end
end
