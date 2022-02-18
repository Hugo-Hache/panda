defmodule Panda.WinningProbabilityTest do
  use ExUnit.Case

  alias Panda.Match

  import Mox

  setup :verify_on_exit!

  @match %Match{
    id: 42,
    opponents: [
      %{opponent: %{id: 42, name: "Team one", modified_at: "2021-02-17T13:06:13Z"}},
      %{opponent: %{id: 24, name: "Second team", modified_at: "2021-01-20T06:38:02Z"}}
    ]
  }

  setup do
    :ets.delete_all_objects(:winning_probability_cache)
    :ok
  end

  test "compute only direct when enough data" do
    Panda.APIMock.Match
    |> expect(:retrieve, 1, fn _id -> @match end)
    |> expect(:finished_between, 1, fn _first_opponent, _second_opponent ->
      [%Match{winner_id: 42}]
    end)

    assert Panda.WinningProbability.compute(42) == %{"Second team" => 0, "Team one" => 1}
  end

  test "compute global if direct has not enough data" do
    Panda.APIMock.Match
    |> expect(:retrieve, 1, fn _id -> @match end)
    |> expect(:finished_between, 1, fn _first_opponent, _second_opponent -> [] end)
    |> expect(:finished, 2, fn _opponent -> [%Match{winner_id: 42}, %Match{winner_id: 24}] end)

    assert Panda.WinningProbability.compute(42) == %{"Second team" => 0.5, "Team one" => 0.5}
  end

  test "retrieve match is cached" do
    Panda.APIMock.Match
    |> expect(:retrieve, 1, fn _id -> @match end)
    |> expect(:finished_between, 2, fn _first_opponent, _second_opponent -> [] end)
    |> expect(:finished, 4, fn _opponent -> [] end)

    assert Panda.WinningProbability.compute(42) == nil
    assert Panda.WinningProbability.compute(42) == nil
  end
end
