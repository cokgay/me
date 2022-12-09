defmodule Me.Application do
  use Application
  require Logger

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Router,
        options: [
          port: 4201
        ]
      ),
      %{
        id: Database.Supervisor,
        start: {Database.Supervisor, :start_link, []}
      },
      %{
        id: RenderCache.Supervisor,
        start: {RenderCache.Supervisor, :start_link, []}
      }
    ]

    opts = [strategy: :one_for_one, name: Me.Supervisor]

    Logger.debug("Server started at port: 4201")

    Supervisor.start_link(children, opts)
  end
end
