defmodule Landbuyer2025.Repo.Migrations.AddUniqueIndexToAccountIdOnStrategies do
  use Ecto.Migration

  def change do
    create unique_index(:strategies, [:account_id])
  end
end
