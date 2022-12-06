defmodule Utils.Hash do
  def hash(value) do
    :crypto.hash(:sha256, value) |> Base.encode16()
  end

  def compare?(hashed, value) do
    hashed === hash(value)
  end
end
