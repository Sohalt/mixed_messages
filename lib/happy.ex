defmodule Happy do
  @behaviour Mixed

  @impl Mixed
  def name(), do: "soma"

  @impl Mixed
  def transform(msg) do
    if Afinn.score(msg, :en) > 0 do
      msg
    else
      "cheer up"
    end
  end
end
