defmodule ChannelFrontend.Packets.Authentication.Actions do
  @moduledoc """
  TODO: Documentation for ChannelFrontend.Packets.Authentication.Actions
  """

  import SessionManager.Session

  alias DatabaseService.Player.{Account, Accounts}
  alias ElvenGard.Structures.Client
  alias ChannelFrontend.Packets.CharacterLobby.Actions, as: CharacterLobbyActions

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

    record = SessionManager.get_by_id(session_id)
    ^session_id = session(record, :id)
    ^password_sha512 = session(record, :password)
    username = session(record, :username)

    %Account{
      id: account_id,
      username: ^username,
      password: ^password_sha512
    } = account = Accounts.get_by_name(username)

    {:ok, _} = SessionManager.monitor_session(username)
    {:ok, _} = SessionManager.set_player_state(username, :in_lobby)
    new_state = Client.put_metadata(client, :account, account)

    CharacterLobbyActions.send_character_list(client, account_id)

    {:cont, Client.put_metadata(new_state, :auth_step, :done)}
  end
end
