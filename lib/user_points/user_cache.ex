defmodule UserPoints.UserCache do
  use GenServer

  @timeout if Mix.env() == :test, do: 1, else: 60_000

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
    spawn(fn -> update_db() end)
    {:noreply, {gen_max_number(max_number), timestamp}}
  end

  @impl true
  def handle_call(:get_users, _, {max_number, _}) do
    users = do_get_users(max_number)
    {:reply, users, {max_number, current_timestamp()}}
  end

  defp update_db() do
    # TODO
    nil
  end

  defp do_get_users(_max_number) do
    # TODO
    []
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
