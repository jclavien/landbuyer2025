defmodule Landbuyer2025.Repo.Migrations.AddUniqueIndexToAccountIdOnStrategies do
  use Ecto.Migration

  def change do
    # Supprime d'abord l'index non unique s’il existe
    drop_if_exists index(:strategies, [:account_id], name: :strategies_account_id_index)

    # Recrée un index unique sur account_id
    create unique_index(:strategies, [:account_id], name: :strategies_account_id_index)
  end
end
