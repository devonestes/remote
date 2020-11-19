defmodule UserPoints.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # We don't want the cache running in `:test` - we'll start that manually when we need it so we
    # can give it permission to use the Repo
    children =
      if Mix.env() == :test do
        [
          UserPoints.Repo,
          UserPointsWeb.Telemetry,
          {Phoenix.PubSub, name: UserPoints.PubSub},
          UserPointsWeb.Endpoint
        ]
      else
        [
          UserPoints.Repo,
          UserPointsWeb.Telemetry,
          {Phoenix.PubSub, name: UserPoints.PubSub},
          UserPoints.UserCache,
          UserPointsWeb.Endpoint
        ]
      end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UserPoints.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    UserPointsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
