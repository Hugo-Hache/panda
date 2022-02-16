ExUnit.start()

Mox.defmock(Panda.MockWinningProbability, for: Panda.WinningProbability)
Application.put_env(:panda, :winning_probability, Panda.MockWinningProbability)
