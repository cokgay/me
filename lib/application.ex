defmodule Me.Application do
  use Application

  def start(_type, _args) do
    children = [
      %{
        id: Me.Database.Supervisor,
        start: {Me.Database.Supervisor, :start_link, []}
      }
    ]

    opts = [strategy: :one_for_one, name: Me.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
