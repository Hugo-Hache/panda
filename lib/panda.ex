defmodule Panda do
  require Logger

  @spec upcoming_matches :: [Panda.Match.t()]
  def upcoming_matches do
    Panda.API.Match.upcoming()
  end

  def winning_probabilities_for_match(match_id) do
    Panda.WinningProbability.compute(match_id) ||
      Panda.WinningProbability.uncomputable_message()
  end
end
