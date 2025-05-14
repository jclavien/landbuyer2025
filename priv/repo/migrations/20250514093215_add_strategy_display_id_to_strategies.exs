defmodule Landbuyer2025.Repo.Migrations.AddStrategyDisplayIdToStrategies do
  use Ecto.Migration

  def change do
    alter table(:strategies) do
      add :strategy_display_id, :string
    end

    create index(:strategies, [:strategy_display_id])
  end
end
