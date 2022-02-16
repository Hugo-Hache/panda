defmodule Panda.WinningProbability.GlobalTest do
  use ExUnit.Case

  alias Panda.{Match, WinningProbability.Global}

  @match %Match{
    opponents: [
      %{opponent: %{id: 24, name: "One team"}},
      %{opponent: %{id: 42, name: "Team two"}}
    ]
  }

  test "compute compared probabibilities" do
    finished_between =
      build_finished_between(
        [
          %Match{winner_id: 24},
          %Match{winner_id: 24},
          %Match{winner_id: 24},
          %Match{draw: true}
        ],
        [
          %Match{winner_id: 42},
          %Match{draw: true},
          %Match{winner_id: 1},
          %Match{winner_id: 2}
        ]
      )

    assert Global.compute(@match, finished_between) == %{"One team" => 0.75, "Team two" => 0.25}
  end

  test "compute equal probabibilities when same win rate" do
    finished_between =
      build_finished_between(
        [
          %Match{winner_id: 24},
          %Match{winner_id: 24},
          %Match{winner_id: 24},
          %Match{draw: true}
        ],
        [
          %Match{winner_id: 42},
          %Match{winner_id: 42},
          %Match{winner_id: 42},
          %Match{winner_id: 0}
        ]
      )

    assert Global.compute(@match, finished_between) == %{"One team" => 0.5, "Team two" => 0.5}
  end

  test "compute nil probabibilities when empty finished" do
    finished_between = build_finished_between([%Match{winner_id: 24}], [])

    assert Global.compute(@match, finished_between) == nil
  end

  test "compute nil probabibilities when both player never won" do
    finished_between =
      build_finished_between(
        [
          %Match{draw: true},
          %Match{winner_id: 1}
        ],
        [
          %Match{draw: true},
          %Match{winner_id: 0}
        ]
      )

    assert Global.compute(@match, finished_between) == nil
  end

  def build_finished_between(first_opponent_matches, second_opponent_matches) do
    [first_opponent_id, second_opponent_id] = @match.opponents |> Enum.map(& &1.opponent.id)

    fn %{opponent: %{id: id}} ->
      case id do
        ^first_opponent_id ->
          first_opponent_matches

        ^second_opponent_id ->
          second_opponent_matches
      end
    end
  end
end
