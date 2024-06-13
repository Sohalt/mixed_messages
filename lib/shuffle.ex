defmodule Shuffle do
  @behaviour Mixed

  def shuffle_words(sentence) do
    String.split(sentence, " ") |> Enum.shuffle() |> Enum.join(" ")
  end

  def shuffle_words_in_sentences(msg) do
    String.split(msg, ". " |> Enum.map(&shuffle_words/1) |> Enum.join(". "))
  end

  @impl Mixed
  def name(), do: "stirrup"

  @impl Mixed
  def transform(msg), do: shuffle_words_in_sentences(msg)
end
