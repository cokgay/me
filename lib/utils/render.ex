defmodule Utils.Render do
  def send_file(%{status: status} = conn, template, assigns \\ []) do
    body =
      "www"
      |> Path.join(template)
      |> EEx.eval_file(assigns)

    Plug.Conn.send_resp(conn, status || 200, body)
  end
end