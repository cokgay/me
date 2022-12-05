defmodule Models.User do
  @fields [
    :username,
    :password,
    :token,
    :view
  ]
  @enforce_keys @fields
  defstruct @fields
end
