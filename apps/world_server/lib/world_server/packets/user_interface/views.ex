defmodule WorldServer.Packets.UserInterface.Views do
  @moduledoc """
  TODO: Documentation for WorldServer.Packets.UserInterface.Views
  """

  use ElvenGard.View

  @spec render(atom, term) :: String.t()
  def render(:info, attrs) do
    %{message: message} = attrs
    "info #{message}"
  end
end
