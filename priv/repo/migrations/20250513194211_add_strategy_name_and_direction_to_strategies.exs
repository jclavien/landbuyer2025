defmodule Landbuyer2025.Repo.Migrations.AddStrategyNameAndDirectionToStrategies do
  use Ecto.Migration

  def change do
    alter table(:strategies) do
      add :strategy_name, :string, null: false, default: "LandbuyerV3"
      add :direction, :string, null: false, default: "LONG"
    end
  end
end
