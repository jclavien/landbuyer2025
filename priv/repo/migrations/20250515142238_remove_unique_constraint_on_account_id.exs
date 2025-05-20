defmodule Landbuyer2025.Repo.Migrations.RemoveUniqueConstraintOnAccountId do
  use Ecto.Migration

  def change do
    drop index(:strategies, [:account_id], unique: true)
  end
end
