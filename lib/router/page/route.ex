defmodule Router.Page do
  use Plug.Router
  alias Utils.Render

  plug(:match)
  plug(:dispatch)

  get("/", do: Render.send_file(conn, "index.html"))
  get("/sign-in", do: Render.send_file(conn, "sign-in.html"))
  get("/sign-up", do: Render.send_file(conn, "sign-up.html"))
  get("/edit", do: Render.send_file(conn, "edit.html"))

  match(_, do: Plug.Conn.send_resp(conn, 404, "requested page not found!"))
end
