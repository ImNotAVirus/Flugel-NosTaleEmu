defmodule WorldServer.Packets.Player.Actions do
  @moduledoc """
  TODO: Documentation for WorldServer.Packets.Player.Actions
  """

  alias ElvenGard.Structures.Client
  alias WorldServer.Structures.Character
  alias WorldServer.Enums.Character, as: EnumChar
  alias WorldServer.Packets.Player.Views, as: PlayerViews
  alias WorldServer.Packets.Entity.Views, as: EntityViews
  alias WorldServer.Packets.MiniMap.Views, as: MiniMapViews
  alias WorldServer.Packets.Chat.Views, as: ChatViews
  alias WorldServer.Packets.Specialist.Views, as: SpecialistViews
  alias WorldServer.Packets.UserInterface.Views, as: UserInterfaceViews

  @spec game_start(Client.t(), String.t(), map) :: {:cont, Client.t()}
  def game_start(client, _header, _params) do
    # TODO: Load character from Redis
    character = %Character{
      id: 1,
      slot: 1,
      name: "DarkyZ",
      gender: EnumChar.gender_type(:female),
      hair_style: EnumChar.hair_style_type(:hair_style_a),
      hair_color: EnumChar.hair_color_type(:yellow),
      class: EnumChar.class_type(:wrestler),
      level: 92,
      hero_level: 25,
      job_level: 80
    }

    # TODO: Get it from CharacterManagement Service
    sp_points_info = %{
      points: 10000,
      additional_points: 500_000
    }

    Client.send(client, PlayerViews.render(:tit, character))
    Client.send(client, PlayerViews.render(:c_info, character))
    Client.send(client, PlayerViews.render(:fd, character))
    Client.send(client, EntityViews.render(:stat, character))
    Client.send(client, MiniMapViews.render(:at, character))
    Client.send(client, MiniMapViews.render(:c_map, character))
    Client.send(client, SpecialistViews.render(:sp, sp_points_info))

    Client.send(client, UserInterfaceViews.render(:info, %{message: "Welcome !"}))

    # UI skill list => Views.render(:ski, character)
    # UI Sp Points => Views.render(:ski, character)
    # ...

    send_bns(client)

    {:cont, client}
  end

  #
  # Function helpers
  #

  @doc false
  defp send_bns(client) do
    # Get it from a service ???
    messages = Enum.map(1..10, fn x -> "ElvenGard ##{x}" end)

    messages
    |> Enum.with_index()
    |> Stream.map(fn {val, i} -> %{id: i, message: val} end)
    |> Enum.each(&Client.send(client, ChatViews.render(:bn, &1)))
  end
end
