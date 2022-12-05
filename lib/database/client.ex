defmodule Database.Client do
  def find_one(collection, data), do: GenServer.call(:database, {:find_one, collection, data})
  def insert_one(collection, data), do: GenServer.cast(:database, {:insert_one, collection, data})
end
