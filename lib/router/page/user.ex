defmodule Router.Page.User do
  alias Utils.Render

  def handle(%{path_params: %{"username" => username}} = conn, :find_user) do
    result = Database.Client.find_one("users", %{username: username})

    if result === nil do
      Plug.Conn.send_resp(conn, 404, "Username not found")
    else
      handle(conn, result, :process_user)
    end
  end

  def handle(conn, %{"username" => username, "view" => view}, :process_user) do
    theme_name = String.downcase(view["theme"])

    safe_render =
      view
      |> Map.put("username", username)
      |> Render.encode_data()

    Render.send_file(conn, "/themes/#{theme_name}.liquid", safe_render)
  end
end
