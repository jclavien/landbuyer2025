defmodule Landbuyer2025.Repo.Migrations.CreateStrategies do
  use Ecto.Migration

  def change do
    create table(:strategies) do
      add :strategy, :string, null: false
      add :interval, :string, null: false
      add :currency_pair, :string, null: false
      add :decimals, :integer, null: false
      add :take_profit, :float, null: false
      add :stop_loss, :float, null: false
      add :distance, :float, null: false
      add :order_size, :float, null: false
      add :max_orders, :integer, null: false
      add :status, :string, default: "stopped"  # Ex: "stopped", "running", etc.

      timestamps()
    end

    create index(:strategies, [:currency_pair])
  end
end
