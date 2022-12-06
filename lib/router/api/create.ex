defmodule Router.Api.Create do
  alias Plug.Conn
  alias Utils.Turnstile
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

      params["cf-turnstile-response"] === nil ->
        Conn.send_resp(conn, 400, "No captcha parameter found in request")

      true ->
        handle(conn, :check_username)
    end
  end

  def handle(%{body_params: %{"username" => username}} = conn, :check_username) do
    cond do
      not is_binary(username) ->
        Conn.send_resp(
          conn,
          400,
          "Username must be a valid string"
        )

      String.length(username) > 32 || String.length(username) < 3 ->
        Conn.send_resp(
          conn,
          400,
          "Username length must be between 2-32"
        )

      not Regex.match?(~r/^[a-zA-Z0-9_]+$/, username) ->
        Conn.send_resp(
          conn,
          400,
          "Username only can contains alphanumeric characters"
        )

      true ->
        handle(conn, :check_password)
    end
  end

  def handle(%{body_params: %{"password" => password}} = conn, :check_password) do
    cond do
      not is_binary(password) ->
        Conn.send_resp(
          conn,
          400,
          "Password must be a valid string"
        )

      String.length(password) > 72 || String.length(password) < 8 ->
        Conn.send_resp(
          conn,
          400,
          "Password length must be between 8-72"
        )

      true ->
        handle(conn, :check_captcha)
    end
  end

  def handle(%{body_params: %{"cf-turnstile-response" => captcha_token}} = conn, :check_captcha) do
    result = Turnstile.verify?(captcha_token)

    if result === true do
      handle(conn, :check_exists)
    else
      Conn.send_resp(conn, 403, "Invalid captcha token")
    end
  end

  def handle(%{body_params: %{"username" => username}} = conn, :check_exists) do
    result = Client.find_one("users", %{username: username})

    if result === nil do
      handle(conn, :create_user)
    else
      Conn.send_resp(conn, 400, "An account with this username already exists")
    end
  end

  def handle(
        %{
          body_params: %{
            "username" => username,
            "password" => password,
            "cf-turnstile-response" => captcha_token
          }
        } = conn,
        :create_user
      ) do
    hashed_password = Hash.hash(password)
    token = :crypto.hash(:sha256, captcha_token <> hashed_password) |> Base.encode64()

    user = %{
      username: username,
      password: hashed_password,
      token: token,
      view: %{
        about: "",
        lanyard_id: "",
        theme: "Classic",
        links: [],
        theme_options: %{}
      }
    }

    Client.insert_one("users", user)
    Conn.resp(conn, 200, token)
  end
end
