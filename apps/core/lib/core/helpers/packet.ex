defmodule Core.PacketHelpers do
  @moduledoc """
  TODO: Documentation for `Core.PacketHelpers`.
  """

  ## Public API

  @doc """
  TODO: Documentation
  """
  @spec serialize_list([term(), ...], String.t()) :: String.t()
  def serialize_list(enumerable, joiner \\ ".")
  def serialize_list([], _), do: "-1"
  def serialize_list([_ | _] = enumerable, joiner), do: Enum.join(enumerable, joiner)
end
