defmodule WorldServer.Packets.Chat.Views do
  @moduledoc """
  TODO: Documentation for WorldServer.Packets.Chat.Views
  """

  use ElvenGard.View

  @spec render(atom, term) :: String.t()
  def render(:bn, attrs) do
    %{
      id: id,
      message: message
    } = attrs

    message_norm = String.replace(message, " ", "^")

    "bn #{id} #{message_norm}"
  end
end
