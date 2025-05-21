defmodule Landbuyer2025.Release do
  @moduledoc false

  def migrate do
    IO.puts("🔄 Démarrage des migrations...")

    Application.load(:landbuyer2025)

    # On démarre uniquement les dépendances nécessaires à Ecto
    start_apps([
      :logger,
      :ssl,
      :crypto,
      :postgrex,
      :ecto,
      :ecto_sql
    ])

    # Puis on démarre notre Repo manuellement
    for repo <- Application.fetch_env!(:landbuyer2025, :ecto_repos) do
      IO.puts("🚀 Lancement de la migration pour #{inspect(repo)}")
      {:ok, _pid} = repo.start_link(pool_size: 2)
      Ecto.Migrator.run(repo, migrations_path(repo), :up, all: true)
    end

    IO.puts("🎉 Toutes les migrations sont terminées.")
  end

  defp start_apps(apps) do
    Enum.each(apps, fn app ->
      case Application.ensure_all_started(app) do
        {:ok, _} ->
          :ok

        {:error, {:already_started, _}} ->
          :ok

        {:error, reason} ->
          IO.puts("❌ Erreur au démarrage de #{app}: #{inspect(reason)}")
          exit(:shutdown)
      end
    end)
  end

  defp migrations_path(repo) do
    app = Keyword.fetch!(repo.config(), :otp_app)
    path = Path.join([:code.priv_dir(app), "repo", "migrations"])
    IO.puts("📁 Chemin des migrations : #{path}")
    path
  end
end
