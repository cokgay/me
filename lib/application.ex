defmodule Me.Application do
  use Application
  require Logger

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Router,
        options: [
          port: port()
        ]
      ),
      %{
        id: Database.Supervisor,
        start: {Database.Supervisor, :start_link, []}
      }
    ]

    opts = [strategy: :one_for_one, name: Me.Supervisor]

    Logger.debug("Server started at: 0.0.0.0:#{port()} !")

    Supervisor.start_link(children, opts)
  end

  defp port, do: Application.get_env(:me, :port) || 4201
end
