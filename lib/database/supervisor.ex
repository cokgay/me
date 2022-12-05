defmodule Me.Database.Supervisor do
  def init(state), do: {:ok, state}

  def start_link() do
    url = Application.get_env(:me, :mongo_url)
    {:ok, conn} = Mongo.start_link(url: url)

    GenServer.start_link(__MODULE__, conn, name: :database)
  end

  def handle_call({:find_one, collection, data}, _from, state) do
    cursor = Mongo.find_one(state, collection, data)
    {:reply, cursor, state}
  end

  def handle_call({:insert_one, collection, data}, _from, state) do
    cursor = Mongo.insert_one(state, collection, data)
    {:reply, cursor, state}
  end
end
