defmodule Silence do
  @behaviour Mixed

  @impl Mixed
  def name(), do: "abyss"

  @impl Mixed
  def transform(_msg),
    do:
      Enum.random([
        "Speech is silver, silence is golden",
        "I have no mouth, and I must scream",
        "😶",
        "🕳️",
        "In space, no one can hear you scream."
      ])
end
