defmodule Landbuyer2025.Repo.Migrations.ChangeIntervalTypeToInteger do
  use Ecto.Migration

  def up do
    execute("""
    ALTER TABLE strategies
    ALTER COLUMN interval TYPE integer
    USING interval::integer
    """)
  end

  def down do
    execute("""
    ALTER TABLE strategies
    ALTER COLUMN interval TYPE varchar
    """)
  end
end
