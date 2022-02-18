defmodule Panda.WinningProbability.GlobalTest do
  use ExUnit.Case

  alias Panda.Match
  alias Panda.WinningProbability.Global

  import Mox

  setup :verify_on_exit!

  @match %Match{
    opponents: [
      %{opponent: %{id: 24, name: "One team"}},
      %{opponent: %{id: 42, name: "Team two"}}
    ]
  }

  test "compute compared probabibilities" do
    mock_finished(
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

    assert Global.compute(@match) == %{"One team" => 0.75, "Team two" => 0.25}
  end

  test "compute equal probabibilities when same win rate" do
    mock_finished(
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

    assert Global.compute(@match) == %{"One team" => 0.5, "Team two" => 0.5}
  end

  test "compute nil probabibilities when empty finished" do
    mock_finished([%Match{winner_id: 24}], [])

    assert Global.compute(@match) == nil
  end

  test "compute nil probabibilities when both player never won" do
    mock_finished(
      [
        %Match{draw: true},
        %Match{winner_id: 1}
      ],
      [
        %Match{draw: true},
        %Match{winner_id: 0}
      ]
    )

    assert Global.compute(@match) == nil
  end

  defp mock_finished(first_opponent_matches, second_opponent_matches) do
    [first_opponent_id, second_opponent_id] = @match.opponents |> Enum.map(& &1.opponent.id)

    Panda.APIMock.Match
    |> expect(
      :finished,
      2,
      fn %{opponent: %{id: id}} ->
        case id do
          ^first_opponent_id ->
            first_opponent_matches

          ^second_opponent_id ->
            second_opponent_matches
        end
      end
    )
  end
end
