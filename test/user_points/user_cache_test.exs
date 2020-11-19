defmodule UserPoints.UserCacheTest do
  use UserPoints.DataCase, async: true

  alias UserPoints.UserCache

  describe "start_link/1" do
    test "starts a cache and schedules a recurring refresh" do
      :erlang.trace(:new_processes, true, [{:tracer, self()}, :receive])
      {:ok, pid} = UserCache.start_link([])
      assert_receive {:trace, ^pid, :receive, :refresh}
      assert {max_number, nil} = :sys.get_state(pid)
      assert max_number >= 0
      assert max_number <= 100

      assert_receive {:trace, ^pid, :receive, :refresh}
      assert {new_number, nil} = :sys.get_state(pid)
      assert new_number >= 0
      assert new_number <= 100
      assert max_number != new_number
    end
  end

  describe "get_users/0" do
    @tag :skip
    test "returns no more than two users" do
    end

    test "sets the timestamp correctly" do
      {:ok, pid} = UserCache.start_link([])

      starting = DateTime.utc_now() |> DateTime.to_unix()
      UserCache.get_users(pid)
      ending = DateTime.utc_now() |> DateTime.to_unix()

      assert {_, timestamp} = :sys.get_state(pid)
      assert timestamp >= starting
      assert timestamp <= ending
    end
  end
end
