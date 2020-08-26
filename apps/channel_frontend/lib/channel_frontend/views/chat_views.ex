defmodule ChannelFrontend.ChatViews do
  @moduledoc """
  TODO: Documentation for ChannelFrontend.ChatViews
  """

  use ElvenGard.View

  alias ChannelFrontend.Enums.Entity, as: EnumsEntity
  alias ChannelFrontend.Enums.Packets.Say, as: EnumsSay

  @spec render(atom(), any()) :: String.t()
  def render(:bn, %{id: id, message: message}) do
    "bn #{id} #{String.replace(message, " ", "^")}"
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
    entity_type = EnumsEntity.type(:character)
    color = Map.get(attrs, :color, EnumsSay.color_type(:default))
    sender_id = 1

    "say #{entity_type} #{sender_id} #{color} #{message}"
  end
end
