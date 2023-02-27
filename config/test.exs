import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :validity_api, ValidityServerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "OhMrkxGfsg7o6csabF3ZuFVUr5JMURSC+DSMFi+/BvfWIVuW4C+Ju6a2rLTE+Npf",
  server: false

# In test we don't send emails.
config :validity_api, ValidityServer.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
