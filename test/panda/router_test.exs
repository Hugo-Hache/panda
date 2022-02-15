defmodule Panda.RouterTest do
  use ExUnit.Case
  use Plug.Test

  alias Panda.Router

  @opts Router.init([])

  test "returns welcome" do
    conn =
      conn(:get, "/")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Welcome 🐼"
  end

  test "returns 404" do
    conn =
      conn(:get, "/missing")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "Oops!"
  end
end
