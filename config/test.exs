use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :eagle_eye, EagleEye.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :eagle_eye, EagleEye.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "eagle_eye_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
