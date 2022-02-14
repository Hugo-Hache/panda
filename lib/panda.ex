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
          scheduled_at: "2022-02-14T15:00:00Z"
        }
      ]
  """
  @spec upcoming_matches :: [Panda.Match.t()]
  def upcoming_matches do
    Panda.Match.upcoming()
  end
end
