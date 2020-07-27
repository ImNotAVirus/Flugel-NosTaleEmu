defmodule ChannelAuth.Worker do
  @moduledoc false

  use GenServer

  require Logger

  import ChannelAuth.Handshake
  import SessionManager.Session, only: [session: 2]

  alias Core.TimeHelpers
  alias ChannelAuth.Handshake
  alias DatabaseService.Player.{Account, Accounts}
  alias ElvenGard.Structures.Client

  @ttl_sec 10
  @ttl_ms @ttl_sec * 1000

  @doc false
  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  ## Genserver behaviour

  @impl true
  def init(_) do
    :timer.send_interval(@ttl_ms, :clean_handshakes)
    Logger.info("ChannelAuth started")
    {:ok, %{}}
  end

  @impl true
  def handle_call({:handle_packet, "encryption_key", params, client}, {from, _}, state) do
    %{encryption_key: encryption_key} = params

    if Map.has_key?(state, from) do
      return_error(:encryption_key_already_defined, from, state)
    else
      expire = TimeHelpers.ttl_to_expire(@ttl_sec)
      record = handshake(encryption_key: encryption_key, expire: expire)
      new_state = Map.put(state, from, record)

      new_client =
        client
        |> Client.put_metadata(:auth_step, :waiting_session)
        |> Client.put_metadata(:encryption_key, encryption_key)

      {:reply, {:ok, new_client}, new_state}
    end
  end

  def handle_call({:handle_packet, "session_id", params, client}, {from, _}, state) do
    %{session_id: session_id} = params

    case Map.get(state, from) do
      nil ->
        return_error(:unknown_handshake, from, state)

      record when handshake(record, :session_id) != nil ->
        return_error(:invalid_handshake, from, state)

      record ->
        expire = TimeHelpers.ttl_to_expire(@ttl_sec)
        new_record = handshake(record, session_id: session_id, expire: expire)
        new_state = Map.put(state, from, new_record)
        new_client = Client.put_metadata(client, :auth_step, :waiting_password)
        {:reply, {:ok, new_client}, new_state}
    end
  end

  def handle_call({:handle_packet, "password", params, client}, {from, _}, state) do
    %{password: password} = params

    case Map.get(state, from) do
      nil ->
        return_error(:unknown_handshake, from, state)

      record when handshake(record, :session_id) == nil ->
        return_error(:invalid_handshake, from, state)

      record ->
        new_state = Map.delete(state, from)
        result = validate_handshake(record, password, client, from)
        {:reply, result, new_state}
    end
  end

  @impl true
  def handle_info(:clean_handshakes, state) do
    curr_time = DateTime.to_unix(DateTime.utc_now())

    new_state =
      state
      |> Map.to_list()
      |> Enum.reduce([], fn
        {index, record}, acc when handshake(record, :expire) <= curr_time -> [index | acc]
        _, acc -> acc
      end)
      |> Enum.reduce(state, &Map.delete(&2, &1))

    {:noreply, new_state}
  end

  ## Private function

  @doc false
  @spec return_error(atom(), GenServer.server(), map()) :: {:reply, {:error, atom()}, map()}
  defp return_error(error, from, state) do
    new_state = Map.delete(state, from)
    {:reply, {:error, error}, new_state}
  end

  @doc false
  @spec validate_handshake(Handshake.t(), String.t(), Client.t(), GenServer.server()) ::
          {:ok, Client.t()} | {:error, atom()}
  defp validate_handshake(record, password, client, from) do
    session_id = handshake(record, :session_id)
    password_sha512 = :crypto.hash(:sha512, password) |> Base.encode16()

    session_record = SessionManager.get_by_id(session_id)
    ^session_id = session(session_record, :id)
    ^password_sha512 = session(session_record, :password)
    username = session(session_record, :username)

    %Account{
      id: account_id,
      username: ^username,
      password: ^password_sha512
    } = account = Accounts.get_by_name(username)

    {:ok, _} = SessionManager.monitor_session(username, from)
    {:ok, _} = SessionManager.set_player_state(username, :in_lobby)

    new_client =
      client
      |> Client.put_metadata(:account, account)
      |> Client.put_metadata(:auth_step, :done)

    ChannelLobby.send_character_list(client, account_id)
    {:ok, new_client}
  rescue
    error ->
      Logger.error("Invalid handshake: #{inspect(error)}")
      {:error, :invalid_handshake}
  end
end
