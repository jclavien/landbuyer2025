defmodule Landbuyer2025.Release do
  @moduledoc false

  def migrate do
    IO.puts("🔄 Démarrage des migrations...")

    Application.load(:landbuyer2025)

    for repo <- Application.fetch_env!(:landbuyer2025, :ecto_repos) do
      IO.puts("🚀 Lancement de la migration pour #{inspect(repo)}")
      {:ok, _} = repo.start_link(pool_size: 2)
      IO.puts("✅ Repo démarré, lancement des migrations...")
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
