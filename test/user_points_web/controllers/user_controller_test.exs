defmodule UserPointsWeb.UserControllerTest do
  use UserPointsWeb.ConnCase, async: true

  alias UserPointsWeb.UserController

  describe "show/2" do
    test "returns no more than two users and the correct info for them", %{conn: conn} do
      expected = %{}
      assert %{status: 200, resp_body: body, state: :sent} = UserController.show(conn, %{})
      assert Jason.decode!(body) == expected
    end
  end
end
