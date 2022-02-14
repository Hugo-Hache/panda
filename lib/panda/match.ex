defmodule Panda.Match do
  import Panda.Request

  defstruct [:id, :scheduled_at, :begin_at, :name]

  @type t :: %Panda.Match{
          id: integer(),
          scheduled_at: String.t(),
          begin_at: String.t(),
          name: String.t()
        }

  @spec upcoming :: [t]
  def upcoming do
    get("/matches/upcoming", %{"page[size]" => 5, sort: "begin_at"})
    |> Enum.map(&from_json/1)
  end

  defp from_json(json), do: struct(Panda.Match, json)
end
