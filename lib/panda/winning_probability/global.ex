defmodule Panda.WinningProbability.Global do
  @spec compute(Panda.Match.t()) :: nil | %{String.t() => float}
  def compute(%Panda.Match{opponents: opponents}) do
    [%{opponent: %{name: first_name}}, %{opponent: %{name: second_name}}] = opponents

    opponents
    |> Enum.map(fn opponent ->
      api_match().finished(opponent)
      |> outcomes(opponent.opponent.id)
      |> probabilities
    end)
    |> compare_probabilities(first_name, second_name)
  end

  defp outcomes(matches, opponent_id) do
    Enum.reduce(matches, %{win: 0, draw: 0, defeat: 0}, fn match, outcomes ->
      case match do
        %{winner_id: ^opponent_id} -> Map.update!(outcomes, :win, &(&1 + 1))
        %{draw: true} -> Map.update!(outcomes, :draw, &(&1 + 1))
        _ -> Map.update!(outcomes, :defeat, &(&1 + 1))
      end
    end)
  end

  defp probabilities(%{win: 0, draw: 0, defeat: 0}), do: nil

  defp probabilities(%{win: win, draw: draw, defeat: defeat}) do
    total = win + draw + defeat
    %{win: win / total, draw: draw / total, defeat: defeat / total}
  end

  defp compare_probabilities([nil, _], _, _), do: nil
  defp compare_probabilities([_, nil], _, _), do: nil

  defp compare_probabilities([%{win: first_win}, %{win: second_win}], first_name, second_name) do
    total = first_win + second_win

    if total == 0,
      do: nil,
      else: %{
        first_name => first_win / total,
        second_name => second_win / total
      }
  end

  defp api_match do
    Application.get_env(:panda, :api_match, Panda.API.Match)
  end
end
