import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :landbuyer2025, Landbuyer2025.Repo,
  username: "postgres",
  password: "1234",
  hostname: "localhost",
  database: "landbuyer2025_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :landbuyer2025, Landbuyer2025Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "NAgX2VkzJodOKDK7ACiwx2+L0YFi90W4I3KEg+u8X8iKgLsrrjhD/cJBq/WlnhvG",
  server: false

# In test we don't send emails
config :landbuyer2025, Landbuyer2025.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :landbuyer2025, Landbuyer2025.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "landbuyer2025_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :landbuyer2025, Landbuyer2025Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "5ijuv2Mo4HJYoK1Z3ivIKEt5eCOX0TFgoqD/0VtcnxUXAOBd6O6GaNb3Ayc2T8pF",
  server: false

# In test we don't send emails
config :landbuyer2025, Landbuyer2025.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
