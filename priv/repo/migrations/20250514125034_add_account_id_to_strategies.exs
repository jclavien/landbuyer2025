defmodule Landbuyer2025.Repo.Migrations.AddAccountIdToStrategies do
  use Ecto.Migration

  def change do
    alter table(:strategies) do
      add :account_id, references(:accounts, on_delete: :delete_all), null: false
    end

    create index(:strategies, [:account_id])
  end
end
