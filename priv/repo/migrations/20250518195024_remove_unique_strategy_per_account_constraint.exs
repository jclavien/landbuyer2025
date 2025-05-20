defmodule Landbuyer2025.Repo.Migrations.RemoveUniqueStrategyPerAccountConstraint do
  use Ecto.Migration

  def change do
    drop_if_exists index(:strategies, [:account_id], name: "unique_strategy_per_account")
  end
end
