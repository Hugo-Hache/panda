defmodule Panda.WinningProbability do
  @callback compute(integer) :: map() | nil
  @callback uncomputable_message :: String.t()

  @newcomer_max_age 30

  @spec compute(integer) :: map | nil
  def compute(match_id) do
    match = retrieve_match(match_id)

    [Panda.WinningProbability.Direct, Panda.WinningProbability.Global]
    |> first_computable_strategy(match)
  end

  @spec uncomputable_message :: String.t()
  def uncomputable_message,
    do: "The track record of those teams is too scarce to compute winning probabilities"

  defp retrieve_match(match_id) do
    case :ets.lookup(:winning_probability_cache, match_id) do
      [] ->
        api_match().retrieve(match_id)
        |> tap(&:ets.insert(:winning_probability_cache, {match_id, &1}))

      [{_, match}] ->
        match
    end
  end

  defp first_computable_strategy(strategies, match) do
    # serial is faster if direct resolves, ie opponents played enough against each other
    cond do
      newcomer?(match) -> parallel_first_computable_strategy(strategies, match)
      true -> serial_first_computable_strategy(strategies, match)
    end
  end

  defp serial_first_computable_strategy(strategies, match),
    do: strategies |> Enum.find_value(nil, & &1.compute(match))

  defp parallel_first_computable_strategy(strategies, match) do
    strategies
    |> Task.async_stream(& &1.compute(match))
    |> Enum.find_value(nil, fn {:ok, val} -> val end)
  end

  defp newcomer?(match) do
    match.opponents
    |> Enum.any?(fn %{opponent: %{modified_at: modified_at}} ->
      {:ok, dt, _} = modified_at |> DateTime.from_iso8601()

      Date.diff(Date.utc_today(), DateTime.to_date(dt)) < @newcomer_max_age
    end)
  end

  defp api_match do
    Application.get_env(:panda, :api_match, Panda.API.Match)
  end
end
