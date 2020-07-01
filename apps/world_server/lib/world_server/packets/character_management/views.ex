defmodule WorldServer.Packets.CharacterManagement.Views do
  @moduledoc """
  TODO: Documentation for WorldServer.Packets.CharacterManagement.Views
  """

  use ElvenGard.View

  @spec render(atom(), any()) :: String.t()
  def render(:success, _) do
    "success"
  end

  def render(:name_already_used, _) do
    "infoi 875 0 0 0"
  end

  def render(:creation_failed, _) do
    "infoi 876 0 0 0"
  end

  def render(:invalid_password, _) do
    "infoi 360 0 0 0"
  end
end
