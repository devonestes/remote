defmodule UserPoints.UserCache do
  use GenServer

  def start_link(opts \\ [name: __MODULE__]) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def get_users() do
    GenServer.call(__MODULE__, :get_users)
  end

  @impl true
  def init(_) do
    schedule_refresh()
    {:ok, {gen_max_number(), nil}}
  end

  @impl true
  def handle_info(:refresh, {_, timestamp}) do
    schedule_refresh()
    spawn(fn -> update_db() end)
    {:noreply, {gen_max_number(), timestamp}}
  end

  @impl true
  def handle_call(:get_users, _, {max_number, _}) do
    users = get_users(max_number)
    {:reply, users, {max_number, current_timestamp()}}
  end

  defp update_db() do
    # TODO
    nil
  end

  defp get_users(_max_number) do
    # TODO
    []
  end

  defp schedule_refresh(), do: Process.send_after(self(), :refresh, 60_000)

  defp current_timestamp(), do: DateTime.utc_now() |> DateTime.to_unix()

  defp gen_max_number(), do: 0..100 |> Enum.take_random(1) |> hd()
end
