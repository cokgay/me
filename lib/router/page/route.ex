defmodule Router.Page do
  use Plug.Router
  alias Utils.Render

  plug(:match)
  plug(:dispatch)

  get("/", do: Render.send_file(conn, "index.liquid"))
  get("/sign-in", do: Render.send_file(conn, "sign-in.liquid"))
  get("/sign-up", do: Render.send_file(conn, "sign-up.liquid"))
  get("/edit", do: Render.send_file(conn, "edit.liquid"))
  get("/@:username", do: Router.Page.User.handle(conn, :find_user))

  match(_, do: Plug.Conn.send_resp(conn, 404, "requested page not found!"))
end
