use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :url_shortener, UrlShortener.Endpoint,
  http: [port: 4001],
  server: false,
  debug_errors: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :url_shortener, UrlShortener.Repo,
  adapter: Sqlite.Ecto,
  username: "postgres",
  password: "postgres",
  database: "url_shortener_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
