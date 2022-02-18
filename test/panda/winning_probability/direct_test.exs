defmodule Panda.WinningProbability.DirectTest do
  use ExUnit.Case

  import Mox

  alias Panda.Match
  alias Panda.WinningProbability.Direct

  @match %Match{
    opponents: [
      %{opponent: %{id: 24, name: "One team"}},
      %{opponent: %{id: 42, name: "Team two"}}
    ]
  }

  test "compute nominal probabibilities" do
    Panda.APIMock.Match
    |> expect(:finished_between, fn _first_opponent, _second_opponent ->
      [
        %Match{winner_id: 24},
        %Match{winner_id: 24},
        %Match{winner_id: 24},
        %Match{draw: true},
        %Match{draw: true},
        %Match{draw: true},
        %Match{winner_id: 42},
        %Match{winner_id: 42}
      ]
    end)

    assert Direct.compute(@match) == %{"One team" => 0.375, "Team two" => 0.25}
  end

  test "compute nil probabibilities when empty finished between" do
    Panda.APIMock.Match
    |> expect(:finished_between, fn _first_opponent, _second_opponent -> [] end)

    assert Direct.compute(@match) == nil
  end
end
