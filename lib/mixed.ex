defmodule Mixed do
  @doc """
  Name of the chatgroup
  """
  @callback name() :: String.t()
  @doc """
  transform message content
  """
  @callback transform(String.t()) :: String.t()
end
