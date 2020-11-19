defmodule UserPointsWeb.UserController do
  use UserPointsWeb, :controller

  def show(conn, _) do
    json(conn, %{})
  end
end
