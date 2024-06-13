defmodule Once do
  @behaviour Mixed

  @impl Mixed
  def name(), do: "once"

  @impl Mixed
  def transform(msg),
    do:
      String.codepoints(msg)
      |> Enum.reduce("", fn c, m ->
        if String.contains?(m, c) do
          m
        else
          m <> c
        end
      end)
end
