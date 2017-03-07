use Mix.Config

config :guardian, Guardian,
  issuer: "MyApp",
  ttl: { 1, :days },
  verify_issuer: true,
  secret_key: "woiuerojksldkjoierwoiejrlskjdf",
  serializer: CuratorRegisterable.Test.GuardianSerializer

config :curator_registerable, CuratorRegisterable,
  repo: CuratorRegisterable.Test.Repo,
  user_schema: CuratorRegisterable.Test.User
