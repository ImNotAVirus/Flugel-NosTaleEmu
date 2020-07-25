defmodule ChannelFrontend.Enums.Packets.Guri do
  @moduledoc """
  TODO: Documentation for ChannelFrontend.Enums.Packets.Guri
  """

  @spec guri_type(atom) :: non_neg_integer
  defmacro guri_type(:emoji), do: 10
  defmacro guri_type(:scene_req_act1), do: 40
  defmacro guri_type(:scene_req_act2), do: 41
  defmacro guri_type(:scene_req_act3), do: 42
  defmacro guri_type(:scene_req_act4), do: 43
  defmacro guri_type(:scene_req_act5), do: 44
end
