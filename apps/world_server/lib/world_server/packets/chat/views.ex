defmodule WorldServer.Packets.Chat.Views do
  @moduledoc """
  TODO: Documentation for WorldServer.Packets.Chat.Views
  """

  use ElvenGard.View

  alias WorldServer.Enums.Entity, as: EnumsEntity
  alias WorldServer.Enums.Packets.Say, as: EnumsSay

  @spec render(atom, term) :: String.t()
  def render(:bn, attrs) do
    %{
      id: id,
      message: message
    } = attrs

    message_norm = String.replace(message, " ", "^")

    "bn #{id} #{message_norm}"
  end

  def render(:say, attrs) when is_binary(attrs) do
    render(:say, %{message: attrs})
  end

  def render(:say, %{color: color} = attrs) when is_atom(color) do
    render(:say, %{attrs | color: EnumsSay.color_type(color)})
  end

  # TODO: Move this function inside Entity module and get sender_id from attrs
  def render(:say, attrs) do
    %{message: message} = attrs
    visual_type = EnumsEntity.visual_type(:character)
    color = Map.get(attrs, :color, EnumsSay.color_type(:default))
    sender_id = 1

    "say #{visual_type} #{sender_id} #{color} #{message}"
  end
end
