defmodule UserPoints.UsersTest do
  use UserPoints.DataCase, async: true

  alias UserPoints.{Repo, Users, User}

  describe "create_user/1" do
    test "creates a single user" do
      assert {:ok, %UserPoints.User{points: 35} = user} = Users.create_user(35)
      assert Repo.all(User) == [user]
    end
  end

  describe "get_users/1" do
    test "returns at most two users with more points than the given max number" do
      Users.create_user(36)
      Users.create_user(37)
      assert [_] = Users.get_users(36)

      Users.create_user(38)
      Users.create_user(39)
      assert [_, _] = Users.get_users(36)
    end
  end
end
