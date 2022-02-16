defmodule Panda.WinningProbability do
  @callback compute(integer) :: map() | nil
  @callback uncomputable_message :: String.t()

  @spec compute(integer) :: map | nil
  def compute(match_id) do
    match = Panda.Match.retrieve(match_id)

    strategies = [Panda.WinningProbability.Direct, Panda.WinningProbability.Global]

    Enum.reduce_while(strategies, nil, fn strategy, default ->
      case strategy.compute(match) do
        nil -> {:cont, default}
        winning_probabilities -> {:halt, winning_probabilities}
      end
    end)
  end

  @spec uncomputable_message :: String.t()
  def uncomputable_message,
    do: "The track record of those teams is too scarce to compute winning probabilities"
end
