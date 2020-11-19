defmodule UserPointsWeb.UserController do
  use UserPointsWeb, :controller

  alias UserPoints.UserCache

  def show(conn, _) do
    {users, timestamp} = UserCache.get_users()
    users = Enum.map(users, &%{id: &1.id, points: &1.points})
    json(conn, %{timestamp: timestamp, users: users})
  end
end
