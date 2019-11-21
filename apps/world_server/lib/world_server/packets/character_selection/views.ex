defmodule WorldServer.Packets.CharacterSelection.Views do
  @moduledoc """
  TODO: Documentation for WorldServer.Packets.CharacterSelection.Views
  """

  use ElvenGard.View

  alias WorldServer.Types.Character

  @spec render(atom, term) :: String.t()
  def render(:ok, _) do
    "OK"
  end

  def render(:clist_start, _) do
    "clist_start 0"
  end

  def render(:clist_end, _) do
    "clist_end"
  end

  def render(:clist, %Character{} = character) do
    "clist #{Character.encode(character)}"
  end
end
