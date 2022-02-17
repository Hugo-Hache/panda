defmodule Panda.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Panda.Router, options: [port: 8080]}
    ]

    Logger.info("Starting Panda server on port 8080 ...")
    :ets.new(:winning_probability_cache, [:public, :protected, :named_table])

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Panda.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
