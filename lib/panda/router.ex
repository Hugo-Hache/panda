defmodule Panda.Router do
  use Plug.Router
  use Plug.ErrorHandler
  require Jason

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Welcome 🐼")
  end

  get "/matches/:id/winning_probabilities" do
    case winning_probability().compute(id) do
      nil ->
        send_resp(
          conn,
          422,
          %{error: winning_probability().uncomputable_message()} |> Jason.encode!()
        )

      winning_probability ->
        send_resp(conn, 200, winning_probability |> Jason.encode!())
    end
  end

  match _ do
    send_resp(conn, 404, "This route does not exist")
  end

  @impl Plug.ErrorHandler
  def handle_errors(conn, %{kind: _kind, reason: reason}) do
    case reason do
      %Panda.Request.NotFoundError{} -> send_resp(conn, 404, "Record not found")
      _ -> send_resp(conn, 500, "Something went wrong")
    end
  end

  defp winning_probability do
    Application.get_env(:panda, :winning_probability, Panda.WinningProbability)
  end
end
