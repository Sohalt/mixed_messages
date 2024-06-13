defmodule Sieve do
  @behaviour Mixed

  @impl Mixed
  def name(), do: "sieve"

  @impl Mixed
  def transform(msg) do
    if(:rand.uniform() > 0.5) do
      IO.puts("send")
      msg
    else
      IO.puts("drop")
      {:stop, :drop}
    end
  end
end
