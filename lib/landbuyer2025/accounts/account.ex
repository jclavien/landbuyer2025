defmodule Landbuyer2025.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :account_display_id, :string
    field :name, :string
    field :id_oanda, :string
    field :service, :string
    field :token, :binary
    field :status, :string, default: "active"

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:account_display_id, :name, :id_oanda, :service, :token, :status])
    |> validate_required([:name, :id_oanda, :service, :token])
    |> unique_constraint(:account_display_id)
  end
end
