defmodule Landbuyer2025.Release do
  @moduledoc false

  def migrate do
    IO.puts("🔄 Démarrage des migrations...")

    # Charge l'application
    Application.load(:landbuyer2025)

    # Démarre toutes les dépendances nécessaires
    {:ok, _} = Application.ensure_all_started(:landbuyer2025)

    # Récupère les repos Ecto et applique les migrations
    for repo <- Application.fetch_env!(:landbuyer2025, :ecto_repos) do
      IO.puts("🚀 Lancement de la migration pour #{inspect(repo)}")
      Ecto.Migrator.run(repo, migrations_path(repo), :up, all: true)
    end

    IO.puts("🎉 Toutes les migrations sont terminées.")
  end

  defp migrations_path(repo) do
    app = Keyword.fetch!(repo.config(), :otp_app)
    path = Path.join([:code.priv_dir(app), "repo", "migrations"])
    IO.puts("📁 Chemin des migrations : #{path}")
    path
  end
end
