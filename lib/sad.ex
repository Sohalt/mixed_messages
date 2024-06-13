defmodule Sad do
  @behaviour Mixed

  @impl Mixed
  def name(), do: "sad"

  @impl Mixed
  def transform(msg) do
    if Afinn.score(msg, :en) > 0 do
      "more doom"
    else
      msg
    end
  end
end
