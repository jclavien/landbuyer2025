defmodule Landbuyer2025.Strategies do
  @moduledoc false

  import Ecto.Query, warn: false
  alias Landbuyer2025.Repo
  # alias Landbuyer2025.Accounts.Account
  alias Landbuyer2025.Strategies.Strategy

  # === REGISTRE DES STRATEGIES DISPONIBLES (modules de logique métier) ===

  @type success() :: {:success, atom(), map()}
  @type nothing() :: {:nothing, atom(), map()}
  @type error() :: {:error, atom(), map()}
  @type event() :: success() | nothing() | error()
  @type events() :: [event()]

  @spec all_modules() :: [atom()]
  def all_modules do
    [
      Landbuyer2025.Strategies.Empty,
      Landbuyer2025.Strategies.LandbuyerV3
    ]
  end

  # === CONTEXTE ECTO : Accès DB ===

  def list_strategies, do: Repo.all(Strategy)

  def get_strategy!(id), do: Repo.get!(Strategy, id)

  def get_latest_strategy_for_account(account_id) do
    from(s in Landbuyer2025.Strategies.Strategy,
      where: s.account_id == ^account_id,
      order_by: [desc: s.inserted_at],
      limit: 1
    )
    |> Landbuyer2025.Repo.one()
  end

  def create_strategy(attrs \\ %{}) do
    next_display_id = get_next_display_id()

    attrs = Map.put(attrs, :strategy_display_id, next_display_id)

    %Strategy{}
    |> Strategy.changeset(attrs)
    |> Repo.insert()
  end

  def change_strategy(%Strategy{} = strategy, attrs \\ %{}) do
    Strategy.changeset(strategy, attrs)
  end

  defp get_next_display_id do
    last_display_id =
      from(s in Strategy,
        where: not is_nil(s.strategy_display_id),
        order_by: [desc: s.strategy_display_id],
        limit: 1,
        select: s.strategy_display_id
      )
      |> Repo.one()

    next_id =
      case last_display_id do
        nil -> 1
        "S" <> rest -> String.to_integer(rest) + 1
      end

    "S" <> String.pad_leading("#{next_id}", 4, "0")
  end
end
