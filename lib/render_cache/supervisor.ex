defmodule RenderCache.Supervisor do
  def init(state), do: {:ok, state}

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: :render_cache)
  end

  def handle_call({:compile, file}, _from, state) do
    if state[file] === nil do
      parsed = File.read!(file) |> Solid.parse!()
      new_state = state |> Map.put(file, parsed)

      {:reply, parsed, new_state}
    else
      {:reply, state[file], state}
    end
  end
end
