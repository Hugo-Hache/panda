# Panda

Small client for the [Pandascore API](https://developers.pandascore.co/docs)

## Usage

```
# PANDASCORE_API_KEY=<YOUR_KEY> iex -S mix
iex > Panda.upcoming_matches
iex > Panda.winning_probabilities_for_match(match_id)
```

Or start the server with `PANDASCORE_API_KEY=<YOUR_KEY> mix run --no-halt`.

## Identified improvement area

- Replace returns values `result | nil` by idiomatic `{:ok, result} | {:error, error_code}`
- Replace `Panda.WinningProbability.uncomputable_message` by an idiomatic way to store and access wording (error tuple would be a bad place as code is a better practice)
- Find a better heuristic to decide between serial or parallel computations of winning probability strategies
- Evaluate the proper way the supervise the :ets table used by winning probability
- Disable Plug.Logger during tests
