defmodule WorldServer.Enums.Packets.Guri do
  @moduledoc """
  TODO: Documentation for WorldServer.Enums.Packets.Guri
  """

  @spec guri_type(atom) :: non_neg_integer
  defmacro guri_type(:emoji), do: 10
  defmacro guri_type(:scene_req_atc1), do: 40
  defmacro guri_type(:scene_req_atc2), do: 41
  defmacro guri_type(:scene_req_atc3), do: 42
  defmacro guri_type(:scene_req_atc4), do: 43
  defmacro guri_type(:scene_req_atc5), do: 44
end
