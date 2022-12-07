defmodule RenderCache.Client do
  def compile(file), do: GenServer.call(:render_cache, {:compile, file})
end
