defmodule Landbuyer2025.Repo.Migrations.CreateStrategySnapshots do
  use Ecto.Migration

  def change do
    create table(:strategy_snapshots) do
      add :strategy_id, references(:strategies, on_delete: :delete_all), null: false
      add :strategy_display_id, :string, null: false
      add :strategy_name, :string, null: false
      add :interval, :integer, null: false
      add :currency_pair, :string, null: false
      add :decimals, :integer, null: false
      add :take_profit, :float, null: false
      add :stop_loss, :float, null: false
      add :distance, :float, null: false
      add :order_size, :float, null: false
      add :max_orders, :integer, null: false
      add :direction, :string, null: false
      add :status, :string, null: false

      timestamps()
    end

    create index(:strategy_snapshots, [:strategy_id])
  end
end
