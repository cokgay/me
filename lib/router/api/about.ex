defmodule Router.Api.About do
  alias Plug.Conn
  alias Utils.Render

  def handle(%{query_params: params} = conn, :check_params) do
    cond do
      params === nil ->
        Conn.send_resp(conn, 400, "No parameter found for body")

      params["username"] !== nil ->
        handle(conn, :fetch_from_username)

      params["token"] !== nil ->
        handle(conn, :fetch_from_token)

      true ->
        Conn.send_resp(conn, 400, "No 'token' or 'username' parameter found in parameters")
    end
  end

  def handle(%{query_params: %{"username" => username}} = conn, :fetch_from_username) do
    result = Database.Client.find_one("users", %{username: username})

    if result === nil do
      Conn.send_resp(conn, 404, "User not found")
    else
      Render.send_json(conn, 200, result["view"])
    end
  end

  def handle(%{query_params: %{"token" => token}} = conn, :fetch_from_token) do
    result = Database.Client.find_one("users", %{token: token})

    if result === nil do
      Conn.send_resp(conn, 404, "User not found")
    else
      Render.send_json(
        conn,
        200,
        result
        |> Map.delete("_id")
        |> Map.delete("password")
      )
    end
  end
end
