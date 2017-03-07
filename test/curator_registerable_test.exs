defmodule CuratorRegisterableTest do
  use ExUnit.Case
  doctest CuratorRegisterable

  use CuratorRegisterable.TestCase

  setup do
    changeset = User.changeset(%User{}, %{
      name: "Test User",
      email: "test_user@test.com",
    })
    |> User.password_changeset(%{password: "TEST_PASSWORD", password_confirmation: "TEST_PASSWORD"})

    user = Repo.insert!(changeset)

    { :ok, %{
        user: user,
      }
    }
  end

  test "verify_password with no user" do
    refute CuratorRegisterable.verify_password(nil, "WRONG_PASSWORD")
  end

  test "verify_password with an invalid password", %{user: user} do
    refute CuratorRegisterable.verify_password(user, "WRONG_PASSWORD")
  end

  test "verify_password with a valid password", %{user: user} do
    assert CuratorRegisterable.verify_password(user, "TEST_PASSWORD")
  end
end
