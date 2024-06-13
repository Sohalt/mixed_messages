defmodule DevNull do
  @behaviour Mixed

  @impl Mixed
  def name(), do: "/dev/null"

  @impl Mixed
  def transform(_msg), do: ""
end
