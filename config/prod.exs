import Config

# Endpoint configuration
config :landbuyer2025, Landbuyer2025Web.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  url: [host: System.get_env("PHX_HOST") || "example.com", port: 443, scheme: "https"],
  http: [
    ip: {0, 0, 0, 0, 0, 0, 0, 0},
    port: String.to_integer(System.get_env("PORT") || "4000")
  ],
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE")

# Swoosh configuration
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: Landbuyer2025.Finch
config :swoosh, local: false

# Logger configuration
config :logger, level: :info
