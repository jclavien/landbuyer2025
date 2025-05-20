defmodule Landbuyer2025.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Landbuyer2025.Repo
  alias Landbuyer2025.Accounts.Account

  def get_account!(id), do: Repo.get!(Account, id)

  def change_account(%Account{} = account \\ %Account{}) do
    Account.changeset(account, %{})
  end

  def create_account(attrs \\ %{}) do
    next_display_id = get_next_display_id()

    encrypted_token =
      attrs[:token]
      |> Landbuyer2025.Encryption.encrypt()

    attrs =
      attrs
      |> Map.put(:account_display_id, next_display_id)
      |> Map.put(:token, encrypted_token)

    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  def close_account(id) do
    account = Repo.get!(Account, id)

    account
    |> Ecto.Changeset.change(status: "closed")
    |> Repo.update()
  end

  def list_accounts do
    from(a in Account, where: a.status == "active")
    |> Repo.all()
  end

  defp get_next_display_id do
    last_display_id =
      from(a in Account,
        where: not is_nil(a.account_display_id),
        order_by: [desc: a.account_display_id],
        limit: 1,
        select: a.account_display_id
      )
      |> Repo.one()

    next_id =
      case last_display_id do
        nil -> 1
        "A" <> rest -> String.to_integer(rest) + 1
      end

    "A" <> String.pad_leading("#{next_id}", 4, "0")
  end
end
