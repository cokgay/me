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
end
