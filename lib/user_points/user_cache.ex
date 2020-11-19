defmodule UserPoints.UserCache do
  use GenServer

  alias UserPoints.Users

  @timeout if Mix.env() == :test, do: 5, else: 60_000

  ## API

  def start_link(opts \\ [name: __MODULE__]), do: GenServer.start_link(__MODULE__, [], opts)

  def get_users(pid \\ __MODULE__), do: GenServer.call(pid, :get_users)

  ## CALLBACKS

  @impl true
  def init(_) do
    schedule_refresh()
    {:ok, {gen_max_number(0), nil}}
  end

  @impl true
  def handle_info(:refresh, {max_number, timestamp}) do
    schedule_refresh()
    update_db()
    {:noreply, {gen_max_number(max_number), timestamp}}
  end

  @impl true
  def handle_call(:get_users, _, {max_number, timestamp}) do
    users = Users.get_users(max_number)
    {:reply, {users, timestamp}, {max_number, current_timestamp()}}
  end

  defp update_db() do
    for user <- Users.list_users() do
      points = gen_max_number(user.points)
      Users.update_user(user, points)
    end
  end

  defp schedule_refresh(), do: Process.send_after(self(), :refresh, @timeout)

  defp current_timestamp(), do: DateTime.utc_now() |> DateTime.to_unix()

  defp gen_max_number(max_number) do
    # This filtering out of the current `max_number` isn't necessary, but makes it so we don't
    # have flaky tests.
    0..100
    |> Enum.to_list()
    |> Kernel.--([max_number])
    |> Enum.take_random(1)
    |> hd()
  end
end
