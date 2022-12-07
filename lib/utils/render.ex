defmodule Utils.Render do
  def send_file(%{status: status} = conn, template, assigns \\ %{}) do
    fs = Solid.LocalFileSystem.new("./www")

    body =
      "www"
      |> Path.join(template)
      |> RenderCache.Client.compile()
      |> Solid.render!(assigns, file_system: {Solid.LocalFileSystem, fs})
      |> to_string

    Plug.Conn.send_resp(conn, status || 200, body)
  end

  def send_json(conn, status, value) do
    encoded = Jason.encode!(value)

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(status, encoded)
  end

  def encode_data(value) when is_binary(value) do
    value
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
    |> String.replace("\"", "&quot;")
    |> String.replace("'", "&#x27;")
  end

  def encode_data(value) when is_list(value) do
    Enum.map(value, fn value ->
      encode_data(value)
    end)
  end

  def encode_data(value) when is_map(value) do
    Enum.map(value, fn {key, value} ->
      {key, encode_data(value)}
    end)
    |> Enum.into(%{})
  end
end
