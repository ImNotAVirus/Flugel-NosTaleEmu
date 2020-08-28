defmodule ChannelFrontend.PlayerActions do
  @moduledoc """
  TODO: Documentation for ChannelFrontend.PlayerActions
  """

  import ChannelCaching.Character, only: [character: 2]

  alias ChannelFrontend.ChatViews
  alias ChannelFrontend.EntityViews
  # alias ChannelFrontend.InventoryViews
  alias ChannelFrontend.PlayerViews
  alias ChannelFrontend.UserInterfaceViews
  alias ElvenGard.Structures.Client

  @spec game_start(Client.t(), String.t(), map) :: {:cont, Client.t()}
  def game_start(client, _header, _params) do
    %{
      character_id: character_id,
      authority: authority
    } = client.metadata

    {:ok, character} = ChannelCaching.get_character_by_id(character_id)
    {:ok, skills} = ChannelCaching.get_skills_by_character_id(character_id)
    quicklist = Enum.map(1..30, fn _ -> "7.7.-1" end)

    c_info_args = %{character: character, authority: authority}

    Client.send(client, PlayerViews.render(:tit, character))
    Client.send(client, PlayerViews.render(:fd, character))
    Client.send(client, PlayerViews.render(:c_info, c_info_args))
    # Client.send(client, InventoryViews.render(:equip, nil))
    Client.send(client, PlayerViews.render(:lev, character))
    Client.send(client, PlayerViews.render(:ski, skills))
    Client.send(client, EntityViews.render(:cond, character))

    ChannelMap.setup_player_map(character, self())

    Client.send(client, PlayerViews.render(:sc, character))
    Client.send(client, EntityViews.render(:pairy, character))
    Client.send(client, PlayerViews.render(:rsfi, nil))
    Client.send(client, PlayerViews.render(:rage, character))
    Client.send(client, PlayerViews.render(:fs, character))
    Client.send(client, EntityViews.render(:stat, character))
    # Client.send(client, SpecialistViews.render(:sp, character))
    Client.send(client, UserInterfaceViews.render(:qslot, %{slot_id: 0, quicklist: quicklist}))
    Client.send(client, UserInterfaceViews.render(:qslot, %{slot_id: 1, quicklist: quicklist}))

    Client.send(client, UserInterfaceViews.render(:info, %{message: "Welcome !"}))

    send_bns(client)
    send_hello(client)

    {:cont, client}
  end

  ## Helpers

  @doc false
  @spec send_bns(Client.t()) :: any()
  defp send_bns(client) do
    messages = Enum.map(1..10, fn x -> "ElvenGard ##{x}" end)

    messages
    |> Enum.with_index()
    |> Stream.map(fn {val, i} -> %{id: i, message: val} end)
    |> Enum.each(&Client.send(client, ChatViews.render(:bn, &1)))
  end

  @doc false
  @spec send_hello(Client.t()) :: any()
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
