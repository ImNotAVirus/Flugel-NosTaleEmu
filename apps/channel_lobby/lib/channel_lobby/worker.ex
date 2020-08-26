defmodule ChannelLobby.Worker do
  @moduledoc false

  use GenServer

  require Logger

  alias ChannelLobby.Views
  alias Core.{CharacterEnums, FrontendHelpers}
  alias DatabaseService.Player.{Character, Characters}
  alias ElvenGard.Structures.Client

  @doc false
  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  ## Genserver behaviour

  @impl true
  def init(_) do
    Logger.info("ChannelLobby started")
    {:ok, nil}
  end

  @impl true
  def handle_cast({:send_character_list, client, account_id}, state) do
    do_send_character_list(client, account_id)
    {:noreply, state}
  end

  @impl true
  def handle_call({:handle_packet, _, _, client}, _from, state)
      when not is_nil(client.metadata.character_id) do
    Logger.warn("Lobby packet received from #{client.metadata.character_id}")
    {:reply, {:ok, client}, state}
  end

  def handle_call({:handle_packet, "Char_NEW", params, client}, _from, state) do
    %{slot: slot} = params
    account_id = client |> Client.get_metadata(:account) |> Map.get(:id)

    with x when is_nil(x) <- Characters.get_by_account_id_and_slot(account_id, slot),
         :ok <- do_create_character(client, account_id, params) do
      :ok
    else
      error ->
        Logger.warn("Character creation failed: #{inspect(error)}")
        FrontendHelpers.send_packet(client, Views.render(:creation_failed, nil))
    end

    {:reply, {:ok, client}, state}
  end

  def handle_call({:handle_packet, "Char_DEL", params, client}, _from, state) do
    %{slot: slot, password: user_input} = params

    with account <- Client.get_metadata(client, :account),
         password <- Map.get(account, :password),
         input_hash when input_hash == password <- hash_password(user_input),
         account_id <- Map.get(account, :id),
         {:ok, _} <- Characters.delete_by_account_id_and_slot(account_id, slot) do
      FrontendHelpers.send_packet(client, Views.render(:success, nil))
      do_send_character_list(client, account_id)
    else
      _ -> FrontendHelpers.send_packet(client, Views.render(:invalid_password, nil))
    end

    {:reply, {:ok, client}, state}
  end

  def handle_call({:handle_packet, "select", params, client}, _from, state) do
    %{slot: slot} = params
    account = Client.get_metadata(client, :account)
    account_id = Map.get(account, :id)
    account_authority = Map.get(account, :authority)
    account_language = Map.get(account, :language)

    new_client =
      case Characters.get_by_account_id_and_slot(account_id, slot) do
        nil ->
          FrontendHelpers.send_packet(client, Views.render(:invalid_select_slot, nil))
          client

        character ->
          %Character{id: character_id} = character
          :ok = ChannelCaching.init_player(account, character)

          FrontendHelpers.send_packet(client, Views.render(:ok, nil))

          # Reduce network load between services
          # TODO: Add `Client.delete_metadata/2` to elvengard-network
          new_metadata = Map.delete(client.metadata, :account)

          %Client{client | metadata: new_metadata}
          |> Client.put_metadata(:character_id, character_id)
          |> Client.put_metadata(:authority, account_authority)
          |> Client.put_metadata(:language, account_language)
      end

    {:reply, {:ok, new_client}, state}
  end

  ## Private functions

  @doc false
  @spec do_send_character_list(Client.t(), pos_integer()) :: :ok
  defp do_send_character_list(client, account_id) do
    character_list = Characters.all_by_account_id(account_id)

    FrontendHelpers.send_packet(client, Views.render(:clist_start, nil))
    Enum.each(character_list, &FrontendHelpers.send_packet(client, Views.render(:clist, &1)))
    FrontendHelpers.send_packet(client, Views.render(:clist_end, nil))
  end

  @doc false
  @spec do_create_character(Client.t(), pos_integer(), map()) :: :ok | :error
  defp do_create_character(client, account_id, params) do
    initial_values = %{
      account_id: account_id,
      class: CharacterEnums.class(:adventurer),
      faction: CharacterEnums.faction(:neutral),
      map_id: 1,
      map_x: :rand.uniform(3) + 77,
      map_y: :rand.uniform(4) + 113
    }

    case params |> Map.merge(initial_values) |> Characters.create() do
      {:ok, _} ->
        # TODO: Create Miniland info here
        FrontendHelpers.send_packet(client, Views.render(:success, nil))
        do_send_character_list(client, account_id)
        :ok

      {:error, _} ->
        :error
    end
  end

  @doc false
  @spec hash_password(String.t()) :: String.t()
  defp hash_password(password) do
    :crypto.hash(:sha512, password) |> Base.encode16()
  end
end
