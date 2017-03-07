defmodule CuratorRegisterable.Config do
  @moduledoc """
  The configuration for CuratorConfirmable.

  ## Configuration

      config :curator_registerable, CuratorRegisterable,
        repo: CuratorRegisterable.Test.Repo,
        user_schema: CuratorRegisterable.Test.User,

  """

  def repo do
    config(:repo, Curator.Config.repo)
  end

  def user_schema do
    config(:user_schema, Curator.Config.user_schema)
  end

  @doc false
  def config, do: Application.get_env(:curator_registerable, CuratorRegisterable, [])
  @doc false
  def config(key, default \\ nil),
    do: config() |> Keyword.get(key, default) |> resolve_config(default)

  defp resolve_config({:system, var_name}, default),
    do: System.get_env(var_name) || default
  defp resolve_config(value, _default),
    do: value
end
