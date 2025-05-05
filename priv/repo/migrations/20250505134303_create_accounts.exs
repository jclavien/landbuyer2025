defmodule Landbuyer2025.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :display_id, :string
      add :name, :string
      add :id_oanda, :string
      add :service, :string
      add :token, :binary
      add :status, :string, default: "active"

      timestamps()
    end

    create unique_index(:accounts, [:display_id])
  end
end
