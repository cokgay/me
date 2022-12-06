defmodule Utils.Render do
  def send_file(%{status: status} = conn, template, assigns \\ []) do
    body =
      "www"
      |> Path.join(template)
      |> EEx.eval_file(assigns)

    Plug.Conn.send_resp(conn, status || 200, body)
  end

  def send_json(conn, status, value) do
    encoded = Jason.encode!(value)

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(status, encoded)
  end
end
