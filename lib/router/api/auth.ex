defmodule Router.Api.Auth do
  alias Plug.Conn
  alias Utils.Hash
  alias Database.Client

  def handle(%{body_params: params} = conn, :check_params) do
    cond do
      params === nil ->
        Conn.send_resp(conn, 400, "No parameter found for body")

      params["username"] === nil ->
        Conn.send_resp(conn, 400, "No username parameter found in request")

      params["password"] === nil ->
        Conn.send_resp(conn, 400, "No password parameter found in request")

      true ->
        handle(conn, :find_user)
    end
  end

  def handle(%{body_params: %{"username" => username}} = conn, :find_user) do
    result = Client.find_one("users", %{username: username})

    if result === nil do
      Conn.send_resp(conn, 404, "User not found")
    else
      handle(conn, result, :auth_user)
    end
  end

  def handle(
        %{body_params: %{"password" => password}} = conn,
        %{"password" => found_password, "token" => found_token},
        :auth_user
      ) do
    if Hash.compare?(found_password, password) do
      Conn.send_resp(conn, 200, found_token)
    else
      Conn.send_resp(conn, 403, "Username or password is wrong")
    end
  end
end
