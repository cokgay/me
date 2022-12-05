defmodule Models.UserView do
  @fields [
    :about,
    :lanyard_id,
    :theme,
    :links,
    :theme_options
  ]
  @enforce_keys @fields
  defstruct @fields
end
