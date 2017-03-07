use Mix.Config

config :logger, level: :warn

config :guardian, Guardian,
  issuer: "MyApp",
  ttl: { 1, :days },
  verify_issuer: true,
  secret_key: "woiuerojksldkjoierwoiejrlskjdf",
  serializer: CuratorRegisterable.Test.GuardianSerializer

config :curator_registerable, CuratorRegisterable,
  repo: CuratorRegisterable.Test.Repo,
  user_schema: CuratorRegisterable.Test.User

config :curator_registerable, ecto_repos: [CuratorRegisterable.Test.Repo]

config :curator_registerable, CuratorRegisterable.Test.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  url: "ecto://localhost/curator_registerable_test",
  size: 1,
  max_overflow: 0,
  priv: "test/support"
