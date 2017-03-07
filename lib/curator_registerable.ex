defmodule CuratorRegisterable do
  @moduledoc """
  CuratorRegisterable: A curator module to handle user "database authentication".
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

  def authenticate(%{"email" => email, "password" => password}) do
    user = Config.repo.get_by(Config.user_schema, email: email)

    case CuratorRegisterable.verify_password(user, password) do
      true -> {:ok, user}
      false -> {:error, user, "Authentication Failure"}
    end
  end

  # def authenticate(params)
  #   login_field = :email
  #   login = params[to_string(login_field)]
  #   user = Repo.get_by(User, [{login_field, login}])
  #   password = params["password"]

  #   CuratorRegisterable.verify_password(user, password)
  # end

  def verify_password(nil, _), do: Config.crypto_mod.dummy_checkpw
  def verify_password(user, password) do
    Config.crypto_mod.checkpw(password, user.password_hash)
  end
end
