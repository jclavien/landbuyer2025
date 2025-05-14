defmodule Landbuyer2025.Repo.Migrations.RemoveStrategyColumnFromStrategies do
  use Ecto.Migration

  def change do
    alter table(:strategies) do
      remove :strategy
    end
  end
end
