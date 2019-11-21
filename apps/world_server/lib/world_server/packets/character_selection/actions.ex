defmodule WorldServer.Packets.CharacterSelection.Actions do
  @moduledoc """
  TODO: Documentation for WorldServer.Packets.CharacterSelection.Actions
  """

  alias ElvenGard.Structures.Client
  alias WorldServer.Enums.Character, as: EnumChar
  alias WorldServer.Structures.Character
  alias WorldServer.Packets.CharacterSelection.Views

  @spec process_session_id(Client.t(), String.t(), %{session_id: integer}) :: {:cont, Client.t()}
  def process_session_id(client, _header, params) do
    new_client =
      client
      |> Client.put_metadata(:session_id, params.session_id)
      |> Client.put_metadata(:auth_step, :waiting_username)

    {:cont, new_client}
  end

  @spec process_username(Client.t(), String.t(), %{username: String.t()}) :: {:cont, Client.t()}
  def process_username(client, _header, params) do
    new_client =
      client
      |> Client.put_metadata(:username, params.username)
      |> Client.put_metadata(:auth_step, :waiting_password)

    {:cont, new_client}
  end

  @spec verify_session(Client.t(), String.t(), %{password: String.t()}) :: {:cont, Client.t()}
  def verify_session(client, _header, params) do
    %{password: _password} = params

    %{
      session_id: _session_id,
      username: username
    } = client.metadata

    # TODO: Check credentials and session_id here

    {:ok, _} = SessionManager.monitor_session(username)
    {:ok, _} = SessionManager.set_player_state(username, :in_lobby)

    # TODO: Load character from the DB Service
    character = %Character{
      slot: 1,
      name: "DarkyZ",
      gender: EnumChar.gender_type(:female),
      hair_style: EnumChar.hair_style_type(:hair_style_b),
      hair_color: EnumChar.hair_color_type(:dark_purple),
      class: EnumChar.class_type(:wrestler),
      level: 92,
      hero_level: 25,
      job_level: 80
    }

    Client.send(client, Views.render(:clist_start, nil))
    Client.send(client, Views.render(:clist, character))
    Client.send(client, Views.render(:clist_end, nil))

    {:cont, Client.put_metadata(client, :auth_step, :done)}
  end
end
