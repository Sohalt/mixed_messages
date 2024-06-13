defmodule Leet do
  @behaviour Mixed

  defp leet_char(c) do
    case c do
      "a" -> "4"
      "e" -> "3"
      "l" -> "1"
      "o" -> "0"
      "s" -> "5"
      "t" -> "7"
      "z" -> "2"
      _ -> c
    end
  end

  def leet_speak(msg) do
    String.downcase(msg) |> String.codepoints() |> Enum.map(&leet_char/1) |> Enum.join("")
  end

  @impl Mixed
  def name(), do: "1337"

  @impl Mixed
  def transform(msg), do: leet_speak(msg)
end
