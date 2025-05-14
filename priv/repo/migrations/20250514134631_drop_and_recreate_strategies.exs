defmodule Landbuyer2025.Repo.Migrations.DropAndRecreateStrategies do
  use Ecto.Migration

  def change do
    drop table(:strategies)

    create table(:strategies) do
      add :strategy_display_id, :string, null: false
      add :strategy_name, :string, null: false
      add :account_id, references(:accounts, on_delete: :delete_all), null: false
      add :interval, :integer, null: false
      add :currency_pair, :string, null: false
      add :decimals, :integer, null: false
      add :take_profit, :float, null: false
      add :stop_loss, :float, null: false
      add :distance, :float, null: false
      add :order_size, :float, null: false
      add :max_orders, :integer, null: false
      add :direction, :string, null: false
      add :status, :string, default: "stopped", null: false

      timestamps()
    end

    create unique_index(:strategies, [:account_id], name: :unique_strategy_per_account)
  end
end
