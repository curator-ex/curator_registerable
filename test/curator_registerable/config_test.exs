defmodule CuratorRegisterable.ConfigTest do
  use ExUnit.Case, async: true
  doctest CuratorRegisterable.Config

  test "the repo" do
    assert CuratorRegisterable.Config.repo == CuratorRegisterable.Test.Repo
  end

  test "the user_schema" do
    assert CuratorRegisterable.Config.user_schema == CuratorRegisterable.Test.User
  end
end
