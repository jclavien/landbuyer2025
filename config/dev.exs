import Config

# --- Affiche les variables d'environnement (pour debug si besoin) ---
IO.inspect(System.get_env("DATABASE_URL"), label: "DATABASE_URL ENV")

# --- Configuration de la base de données ---
config :landbuyer2025, Landbuyer2025.Repo,
  username: "postgres",
  # ← mot de passe correct
  password: "1234",
  hostname: "127.0.0.1",
  database: "landbuyer2025_dev",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

IO.inspect(Application.get_env(:landbuyer2025, Landbuyer2025.Repo), label: "Repo config")

# --- Configuration de l'endpoint Phoenix ---
config :landbuyer2025, Landbuyer2025Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "M4YKSnF5QMgkVhqR4bucx5lS3qLQTX98TH7ywIFyN/PCJOlxoGBSkQOXZaSnJqaj",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:landbuyer2025, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:landbuyer2025, ~w(--watch)]}
  ]

# --- Live reload pour les fichiers statiques et templates ---
config :landbuyer2025, Landbuyer2025Web.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/landbuyer2025_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

# --- Active les routes dev (dashboard, mailbox) ---
config :landbuyer2025, dev_routes: true

# --- Logger ---
config :logger, :console, format: "[$level] $message\n"

# --- Augmente la profondeur des stacktraces pour le dev ---
config :phoenix, :stacktrace_depth, 20

# --- Compile les plugs au runtime pour accélérer le dev ---
config :phoenix, :plug_init_mode, :runtime

# --- Phoenix LiveView debug ---
config :phoenix_live_view,
  debug_heex_annotations: true,
  enable_expensive_runtime_checks: true

# --- Désactive le client API de swoosh (inutile en dev) ---
config :swoosh, :api_client, false
