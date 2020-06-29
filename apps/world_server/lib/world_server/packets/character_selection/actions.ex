defmodule WorldServer.Packets.CharacterSelection.Actions do
  @moduledoc """
  TODO: Documentation for WorldServer.Packets.CharacterSelection.Actions
  """

  alias DatabaseService.Player.{Account, Accounts, Characters}
  alias ElvenGard.Structures.Client
  alias SessionManager.Session
  alias WorldServer.Structures.Character
  alias WorldServer.Enums.Character, as: EnumChar
  alias WorldServer.Packets.CharacterSelection.Views, as: CharSelectViews

  @spec process_encryption_key(Client.t(), String.t(), map) :: {:cont, Client.t()}
  def process_encryption_key(client, _header, params) do
    new_client =
      client
      |> Client.put_metadata(:encryption_key, params.encryption_key)
      |> Client.put_metadata(:auth_step, :waiting_session)

    {:cont, new_client}
  end

  @spec process_session_id(Client.t(), String.t(), map) :: {:cont, Client.t()}
  def process_session_id(client, _header, params) do
    new_client =
      client
      |> Client.put_metadata(:session_id, params.session_id)
      |> Client.put_metadata(:auth_step, :waiting_password)

    {:cont, new_client}
  end

  @spec verify_session(Client.t(), String.t(), map) :: {:cont, Client.t()}
  def verify_session(client, _header, %{password: password}) do
    session_id = Client.get_metadata(client, :session_id)
    password_sha512 = :crypto.hash(:sha512, password) |> Base.encode16()

    %Session{
      id: ^session_id,
      username: username,
      password: ^password_sha512
    } = SessionManager.get_by_id(session_id)

    %Account{
      id: account_id,
      username: ^username,
      password: ^password_sha512
    } = account = Accounts.get_by_name(username)

    {:ok, _} = SessionManager.monitor_session(username)
    {:ok, _} = SessionManager.set_player_state(username, :in_lobby)
    new_state = Client.put_metadata(client, :account, account)

    character_list = Characters.all_by_account(account_id)

    Client.send(client, CharSelectViews.render(:clist_start, nil))
    Enum.each(character_list, &Client.send(client, CharSelectViews.render(:clist, &1)))
    Client.send(client, CharSelectViews.render(:clist_end, nil))

    {:cont, Client.put_metadata(new_state, :auth_step, :done)}
  end

  @spec select_character(Client.t(), String.t(), map) :: {:cont, Client.t()}
  def select_character(client, _header, params) do
    %{character_slot: _character_slot} = params

    # TODO: Load character from the DB Service and cache it
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

    Client.send(client, CharSelectViews.render(:ok, character))

    {:cont, client}
  end
end
