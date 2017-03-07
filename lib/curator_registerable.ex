defmodule CuratorRegisterable do
  @moduledoc """
  CuratorRegisterable: A curator module to handle user registration.
  """

  if !(
       (Application.get_env(:curator_registerable, CuratorRegisterable) && Keyword.get(Application.get_env(:curator_registerable, CuratorRegisterable), :repo)) ||
       (Application.get_env(:curator, Curator) && Keyword.get(Application.get_env(:curator, Curator), :repo))
      ), do: raise "CuratorRegisterable requires a repo"

  if !(
       (Application.get_env(:curator_registerable, CuratorRegisterable) && Keyword.get(Application.get_env(:curator_registerable, CuratorRegisterable), :user_schema)) ||
       (Application.get_env(:curator, Curator) && Keyword.get(Application.get_env(:curator, Curator), :user_schema))
      ), do: raise "CuratorRegisterable requires a user_schema"

  alias CuratorRegisterable.Config
end
