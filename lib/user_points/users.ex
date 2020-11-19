defmodule UserPoints.Users do
  import Ecto.Query

  alias UserPoints.{Repo, User}

  def get_users(max_points) do
    Repo.all(from(u in User, where: u.points > ^max_points, limit: 2))
  end

  def list_users(), do: Repo.all(User)

  def create_user(points) do
    %{points: points}
    |> User.changeset()
    |> Repo.insert()
  end

  def update_user(user, points) do
    user
    |> User.changeset(%{points: points})
    |> Repo.update()
  end
end
