defmodule WorldServer.Enums.Relations do
  @moduledoc """
  TODO: Documentation for WorldServer.Enums.Relations
  """

  @spec character_relation_type(atom) :: integer
  def character_relation_type(:blocked), do: -1
  def character_relation_type(:friend), do: 0
  def character_relation_type(:hidden_spouse), do: 2
  def character_relation_type(:spouse), do: 5

  @spec invitation_process(atom) :: non_neg_integer
  def invitation_process(:accept), do: 0
  def invitation_process(:refuse), do: 1
end
