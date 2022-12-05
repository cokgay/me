defmodule Models.UserLink do
  @fields [
    :display,
    :title,
    :url
  ]
  @enforce_keys @fields
  defstruct @fields
end
