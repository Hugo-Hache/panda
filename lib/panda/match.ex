defmodule Panda.Match do
  import Panda.Request

  defstruct [:id, :scheduled_at, :begin_at, :name, :opponents, :winner_id, :draw]

  @type opponent :: %{
          type: String.t(),
          opponent: %{
            id: integer(),
            name: String.t()
          }
        }

  @type t :: %Panda.Match{
          id: integer(),
          scheduled_at: String.t(),
          begin_at: String.t(),
          name: String.t(),
          opponents: list(opponent()),
          winner_id: integer(),
          draw: boolean()
        }

  @spec retrieve(integer) :: t
  def retrieve(id) do
    get("/matches/#{id}") |> from_json
  end

  @spec upcoming :: [t]
  def upcoming do
    get("/matches/upcoming", %{page: %{size: 5}, sort: "begin_at"})
    |> Enum.map(&from_json/1)
  end

  @spec finished(opponent, map) :: [t]
  def finished(%{opponent: %{id: first_id}, type: type}, filter \\ %{}) do
    resources =
      case type do
        "Team" -> "teams"
        "Player" -> "players"
      end

    get("/#{resources}/#{first_id}/matches", %{
      filter: Map.merge(filter, %{finished: true})
    })
    |> Enum.map(&from_json/1)
  end

  @spec finished_between(opponent, opponent) :: [t]
  def finished_between(first_opponent, %{opponent: %{id: second_id}}) do
    finished(first_opponent, %{opponent_id: second_id})
  end

  defp from_json(json), do: struct(Panda.Match, json)
end
