defmodule Panda.Match do
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
end
