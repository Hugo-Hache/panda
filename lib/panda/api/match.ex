defmodule Panda.API.Match do
  import Panda.API.Request

  alias Panda.Match

  @callback finished(Match.opponent()) :: [Match.t()]
  @callback finished_between(Match.opponent(), Match.opponent()) :: [Match.t()]

  @spec retrieve(integer) :: Match.t()
  def retrieve(id) do
    get("/matches/#{id}") |> to_struct
  end

  @spec upcoming :: [Match.t()]
  def upcoming do
    get("/matches/upcoming", %{page: %{size: 5}, sort: "begin_at"})
    |> Enum.map(&to_struct/1)
  end

  @spec finished(Match.opponent(), map) :: [Match.t()]
  def finished(%{opponent: %{id: first_id}, type: type}, filter \\ %{}) do
    resources =
      case type do
        "Team" -> "teams"
        "Player" -> "players"
      end

    get("/#{resources}/#{first_id}/matches", %{
      filter: Map.merge(filter, %{finished: true})
    })
    |> Enum.map(&to_struct/1)
  end

  @spec finished_between(Match.opponent(), Match.opponent()) :: [Match.t()]
  def finished_between(first_opponent, %{opponent: %{id: second_id}}) do
    finished(first_opponent, %{opponent_id: second_id})
  end

  defp to_struct(json), do: struct(Match, json)
end
