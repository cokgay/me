defmodule Router.Api.Edit do
  alias Plug.Conn

  @themes ["ArtBox", "Black", "MacOS", "Classic"]
  @displays [
    "Website",
    "Discord",
    "Spotify",
    "Youtube",
    "Twitter",
    "SoundCloud",
    "Facebook",
    "Instagram",
    "Steam",
    "GitHub",
    "Reddit",
    "Twitch",
    "TikTok",
    "PayPal",
    "Patreon",
    "DeviantArt",
    "ArtStation",
    "Dribble",
    "Email"
  ]
  @theme_options [
    "backgroundUrl",
    "backgroundColor",
    "secondaryColor",
    "thirdColor",
    "foregroundColor"
  ]

  def handle(%{body_params: params} = conn, :check_params) do
    cond do
      params === nil ->
        Conn.send_resp(conn, 400, "No parameter found for body")

      params["token"] === nil ->
        Conn.send_resp(conn, 400, "No token parameter found in request")

      params["data"] === nil ->
        Conn.send_resp(conn, 400, "No data parameter found in request")

      true ->
        handle(conn, :check_about)
    end
  end

  def handle(%{body_params: %{"data" => %{"about" => about}}} = conn, :check_about) do
    cond do
      not is_binary(about) ->
        Conn.send_resp(conn, 400, "About must be a valid string")

      String.length(about) > 512 ->
        Conn.send_resp(conn, 400, "About length is too much")

      true ->
        handle(conn, :check_lanyard_id)
    end
  end

  def handle(%{body_params: %{"data" => %{"lanyard_id" => lanyard_id}}} = conn, :check_lanyard_id) do
    cond do
      not is_binary(lanyard_id) ->
        Conn.send_resp(conn, 400, "Lanyard ID must be a valid string")

      String.length(lanyard_id) > 32 || not Regex.match?(~r/^[0-9]+$/, lanyard_id) ->
        Conn.send_resp(conn, 400, "Lanyard ID must be a valid number")

      true ->
        handle(conn, :check_theme)
    end
  end

  def handle(%{body_params: %{"data" => %{"theme" => theme}}} = conn, :check_theme) do
    cond do
      not is_binary(theme) ->
        Conn.send_resp(conn, 400, "Theme must be a valid string")

      Enum.member?(@themes, theme) === false ->
        Conn.send_resp(conn, 400, "Not a valid theme")

      true ->
        handle(conn, :check_links)
    end
  end

  def handle(%{body_params: %{"data" => %{"links" => links}}} = conn, :check_links) do
    cond do
      Enum.count(links) > 16 ->
        Conn.send_resp(conn, 400, "Too many links")

      true ->
        handle(conn, :check_links_inside)
    end
  end

  def handle(%{body_params: %{"data" => %{"links" => links}}} = conn, :check_links_inside) do
    try do
      for link <- links do
        %{"title" => title, "url" => url, "display" => display} = link

        cond do
          link |> Map.keys() |> Enum.count() !== 3 ->
            throw(:wrong_format)

          not is_binary(title) || not is_binary(url) || not is_binary(display) ->
            throw(:wrong_format)

          Enum.member?(@displays, display) === false ->
            throw(:unknown_display)

          String.length(title) > 16 ->
            throw(:title_too_long)

          String.length(url) > 256 ->
            throw(:url_too_long)

          display === "Email" && not String.starts_with?(url, "mailto:") ->
            throw(:url_invalid)

          display !== "Email" &&
              not (String.starts_with?(url, "https://") or String.starts_with?(url, "http://")) ->
            throw(:url_invalid)

          true ->
            nil
        end
      end

      handle(conn, :check_theme_config)
    catch
      :wrong_format ->
        Conn.send_resp(conn, 400, "Not a valid link format")

      :unknown_display ->
        Conn.send_resp(conn, 400, "Unknown display value")

      :title_too_long ->
        Conn.send_resp(conn, 400, "Title is too long")

      :url_too_long ->
        Conn.send_resp(conn, 400, "Url is too long")

      :url_invalid ->
        Conn.send_resp(conn, 400, "Invalid url value")
    end
  end

  def handle(
        %{body_params: %{"data" => %{"theme_options" => theme_options}}} = conn,
        :check_theme_config
      ) do
    is_valid_keys =
      theme_options
      |> Map.keys()
      |> Enum.map(fn value -> Enum.member?(@theme_options, value) end)
      |> Enum.all?()

    is_valid_values =
      theme_options
      |> Map.values()
      |> Enum.map(fn value -> is_binary(value) and String.length(value) < 256 end)
      |> Enum.all?()

    if is_valid_keys and is_valid_values do
      handle(conn, :update_data)
    else
      Conn.send_resp(conn, 400, "Invalid theme option")
    end
  end

  def handle(%{body_params: %{"token" => token, "data" => data}} = conn, :update_data) do
    result = Database.Client.find_one("users", %{token: token})

    if result === nil do
      Conn.send_resp(conn, 404, "User not found")
    else
      new_user = %{result | "view" => data}
      Database.Client.replace_one("users", result, new_user)

      Conn.send_resp(conn, 204, "")
    end
  end
end
