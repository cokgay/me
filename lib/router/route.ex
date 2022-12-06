defmodule Router do
  use Plug.Router

  plug(Plug.Static,
    at: "/static",
    from: "www/static"
  )

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    json_decoder: Jason
  )

  plug(:dispatch)

  forward("/api", to: Router.Api)
  forward("/", to: Router.Page)
end
