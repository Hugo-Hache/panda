ExUnit.start()

Mox.defmock(Panda.MockWinningProbability, for: Panda.WinningProbability)
Application.put_env(:panda, :winning_probability, Panda.MockWinningProbability)

Mox.defmock(Panda.APIMock.Match, for: Panda.API.Match)
Application.put_env(:panda, :api_match, Panda.APIMock.Match)
