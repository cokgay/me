defmodule Router.Api do
  use Plug.Router

  alias Router.Api.Create
  alias Router.Api.Auth
  alias Router.Api.About

  plug(:match)
  plug(:dispatch)

  post("/create", do: Create.handle(conn, :check_params))
  post("/auth", do: Auth.handle(conn, :check_params))
  post("/about", do: About.handle(conn, :check_params))

  match(_, do: Plug.Conn.send_resp(conn, 404, "requested page not found!"))
end
