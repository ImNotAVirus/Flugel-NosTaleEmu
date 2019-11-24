defmodule WorldServer.Packets.UserInterface.Actions do
  @moduledoc """
  TODO: Documentation for WorldServer.Packets.UserInterface.Actions
  """

  import WorldServer.Enums.Packets.Guri, only: [guri_type: 1]

  alias ElvenGard.Structures.Client
  alias WorldServer.Structures.Character
  alias WorldServer.Packets.Entity.Views, as: EntityViews
  alias WorldServer.Packets.UserInterface.Views, as: UserInterfaceViews

  @emoji_offset 4099

  @spec guri_handler(Client.t(), String.t(), map) :: {:cont, Client.t()}
  def guri_handler(client, _, %{type: t} = params) when t == guri_type(:emoji) do
    %{
      entity_id: entity_id,
      value: value
    } = params

    # TODO: Get target from EntityService
    data = %{
      target: %Character{id: entity_id},
      value: @emoji_offset + value
    }

    if value >= 973 and value <= 999 do
      # TODO: Broadcast to all players on the same map (check option "emoticons_blocked")
      Client.send(client, EntityViews.render(:eff, data))
    else
      data = %{message: "UNAUTHORIZED_EMOTICON"}
      Client.send(client, UserInterfaceViews.render(:info, data))
    end

    {:cont, client}
  end
end
