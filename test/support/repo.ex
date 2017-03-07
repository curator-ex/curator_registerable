defmodule CuratorRegisterable.Test.Repo do
  use Ecto.Repo, otp_app: :curator_registerable

  def log(_cmd), do: nil
end
