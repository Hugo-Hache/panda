defmodule Panda do
  require Logger

  @moduledoc """
  Documentation for `Panda`.
  """

  @doc """
  Fetch next five upcoming matches, ordered by ascending begin_at.

  ## Examples

      iex> Panda.upcoming_matches()
      [
        %Panda.Match{
          begin_at: "2022-02-14T15:00:00Z",
          id: 621480,
          name: "Lower Bracket Round 3 Match 1: HR vs V-Gaming",
          scheduled_at: "2022-02-14T15:00:00Z",
          draw: false,
          winner_id: nil
          opponents: [...]
        }
      ]
  """
  @spec upcoming_matches :: [Panda.Match.t()]
  def upcoming_matches do
    Panda.Match.upcoming()
  end

  def winning_probabilities_for_match(match_id) do
    Panda.WinningProbability.compute(match_id) ||
      Panda.WinningProbability.uncomputable_message()
  end
end
