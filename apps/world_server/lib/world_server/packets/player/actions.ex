defmodule WorldServer.Packets.Player.Actions do
  @moduledoc """
  TODO: Documentation for WorldServer.Packets.Player.Actions
  """

  alias ElvenGard.Structures.Client
  alias WorldServer.Structures.Character
  alias WorldServer.Enums.Character, as: EnumChar
  alias WorldServer.Packets.Player.Views, as: PlayerViews
  # alias WorldServer.Packets.Inventory.Views, as: InventoryViews
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
      job_level: 80,
      hero_level: 25,
      level_xp: 3_000,
      job_level_xp: 4_500,
      hero_level_xp: 1_000,
      reputation: 5_000_000,
      dignity: 100
    }

    # TODO: Get it from CharacterManagement Service
    sp_points_info = %{
      points: 10_000,
      additional_points: 500_000
    }

    Client.send(client, PlayerViews.render(:tit, character))
    Client.send(client, PlayerViews.render(:fd, character))
    Client.send(client, PlayerViews.render(:c_info, character))
    Client.send(client, PlayerViews.render(:lev, character))
    Client.send(client, PlayerViews.render(:sc, character))
    Client.send(client, EntityViews.render(:stat, character))
    Client.send(client, MiniMapViews.render(:at, character))
    Client.send(client, MiniMapViews.render(:c_map, character))
    Client.send(client, SpecialistViews.render(:sp, sp_points_info))
    # Client.send(client, InventoryViews.render(:equip, nil))

    Client.send(client, UserInterfaceViews.render(:info, %{message: "Welcome !"}))

    # Missing packets (road map):
    #   - equip
    #   - ski
    #   - cond
    #   - pairy
    #   - rsfi
    #   - rank_cool
    #   - scr
    #   - exts
    #   - gidx
    #   - mlinfo
    #   - p_clear
    #   - sc_p
    #   - sc_n
    #   - sc_p_stc
    #   - npinfo
    #   - pinit
    #   - blinit
    #   - post
    #   - zzim
    #   - twk
    #   - qstlist
    #   - sqst
    #   - bf
    #   - ginfo
    #   - gmbr
    #   - in
    #   - out

    send_bns(client)
    send_hello(client)

    {:cont, client}
  end

  #
  # Function helpers
  #

  @doc false
  @spec send_bns(Client.t()) :: term
  defp send_bns(client) do
    # Get it from a service ???
    messages = Enum.map(1..10, fn x -> "ElvenGard ##{x}" end)

    messages
    |> Enum.with_index()
    |> Stream.map(fn {val, i} -> %{id: i, message: val} end)
    |> Enum.each(&Client.send(client, ChatViews.render(:bn, &1)))
  end

  @doc false
  @spec send_hello(Client.t()) :: term
  defp send_hello(client) do
    prefix = String.duplicate("-", 31)
    suffix = String.duplicate("-", 82)

    messages = [
      {:special_green, "#{prefix} [ ElvenGard ] #{prefix}"},
      {:special_red, "Github: https://github.com/ImNotAVirus/Flugel-NostaleEmu"},
      {:special_red, "Author: DarkyZ aka. ImNotAVirus"},
      {:special_green, suffix}
    ]

    Enum.each(messages, fn {color, message} ->
      attrs = %{color: color, message: message}
      Client.send(client, ChatViews.render(:say, attrs))
    end)
  end
end
