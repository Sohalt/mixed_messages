defmodule Scream do
  @behaviour Mixed

  @impl Mixed
  def name(), do: "scream"

  @impl Mixed
  def transform(msg), do: String.upcase(msg)
end
