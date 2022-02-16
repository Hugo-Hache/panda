defmodule Panda.RouterTest do
  use ExUnit.Case
  use Plug.Test

  import Mox

  alias Panda.Router

  @opts Router.init([])

  setup :verify_on_exit!

  test "root returns welcome" do
    conn =
      conn(:get, "/")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Welcome 🐼"
  end

  test "winning_probabilities returns 200 with JSON when probabilities available" do
    Panda.MockWinningProbability
    |> expect(:compute, fn _id -> %{"Team one" => 0.42, "Second team" => 0.24} end)

    conn =
      conn(:get, "/matches/42/winning_probabilities")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "{\"Second team\":0.24,\"Team one\":0.42}"
  end

  test "winning_probabilities returns 422 with JSON when probabilities available" do
    Panda.MockWinningProbability
    |> expect(:compute, fn _id -> nil end)
    |> expect(:uncomputable_message, fn -> "Too scarce" end)

    conn =
      conn(:get, "/matches/42/winning_probabilities")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 422
    assert conn.resp_body == "{\"error\":\"Too scarce\"}"
  end

  test "missing returns 404" do
    conn =
      conn(:get, "/missing")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "This route does not exist"
  end
end
