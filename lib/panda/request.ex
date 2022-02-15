defmodule Panda.Request do
  require Application
  require Logger

  @base_url "https://api.pandascore.co"

  def get(path, params \\ %{}) do
    uri_string =
      @base_url
      |> URI.parse()
      |> Map.put(:path, path)
      |> Map.put(:query, Plug.Conn.Query.encode(params))
      |> URI.to_string()

    token = System.fetch_env!("PANDASCORE_API_KEY")
    headers = [Authorization: "Bearer #{token}", Accept: "application/json"]

    case HTTPoison.get(uri_string, headers) do
      {:ok, %{status_code: 200, body: body}} ->
        Jason.decode!(body, keys: :atoms)

      {:error, %{reason: reason}} ->
        Logger.error("Error while fetching upcoming matches: #{reason}")
    end
  end
end
