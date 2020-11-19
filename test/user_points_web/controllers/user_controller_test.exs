defmodule UserPointsWeb.UserControllerTest do
  use UserPointsWeb.ConnCase, async: true

  alias UserPointsWeb.UserController

  alias UserPoints.{Repo, UserCache, Users}

  describe "show/2" do
    test "returns no more than two users and the correct info for them", %{conn: conn} do
      {:ok, user1} = Users.create_user(201)
      {:ok, user2} = Users.create_user(202)
      users = Enum.map([user1, user2], &%{id: &1.id, points: &1.points})
      expected = %{users: users, timestamp: nil}

      {:ok, cache} = start_supervised(UserCache)
      Process.register(cache, UserCache)
      Ecto.Adapters.SQL.Sandbox.allow(Repo, self(), cache)

      assert %{status: 200, resp_body: body, state: :sent} = UserController.show(conn, %{})
      assert Jason.decode!(body, keys: :atoms) == expected

      assert %{status: 200, resp_body: body, state: :sent} = UserController.show(conn, %{})
      assert %{timestamp: timestamp} = Jason.decode!(body, keys: :atoms)
      assert timestamp >= DateTime.utc_now() |> DateTime.to_unix()
    end
  end
end
