defmodule Panda.WinningProbability.Direct do
  @spec compute(Panda.Match.t()) :: nil | %{String.t() => float}
  def compute(%Panda.Match{opponents: opponents}) do
    [first_opponent, second_opponent] = opponents
    %{id: first_id, name: first_name} = first_opponent.opponent
    %{id: second_id, name: second_name} = second_opponent.opponent

    probabilities =
      api_match().finished_between(first_opponent, second_opponent)
      |> outcomes(first_id, second_id)
      |> probabilities

    case probabilities do
      nil ->
        nil

      %{first_win: first_proba, second_win: second_proba} ->
        %{first_name => first_proba, second_name => second_proba}
    end
  end

  defp outcomes(matches, first_opponent_id, second_opponent_id) do
    Enum.reduce(matches, %{first_win: 0, draw: 0, second_win: 0}, fn match, outcomes ->
      case match do
        %{winner_id: ^first_opponent_id} -> Map.update!(outcomes, :first_win, &(&1 + 1))
        %{draw: true} -> Map.update!(outcomes, :draw, &(&1 + 1))
        %{winner_id: ^second_opponent_id} -> Map.update!(outcomes, :second_win, &(&1 + 1))
      end
    end)
  end

  defp probabilities(%{first_win: 0, draw: 0, second_win: 0}), do: nil

  defp probabilities(%{first_win: first_win, draw: draw, second_win: second_win}) do
    total = first_win + draw + second_win
    %{first_win: first_win / total, draw: draw / total, second_win: second_win / total}
  end

  defp api_match do
    Application.get_env(:panda, :api_match, Panda.API.Match)
  end
end
