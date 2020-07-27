defmodule ChannelLobby.Worker do
  @moduledoc false

  use GenServer

  require Logger

  alias ChannelLobby.Views
  alias DatabaseService.Player.{Account, Character, Characters}
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
    character_list = Characters.all_by_account_id(account_id)

    Client.send(client, Views.render(:clist_start, nil))
    Enum.each(character_list, &Client.send(client, Views.render(:clist, &1)))
    Client.send(client, Views.render(:clist_end, nil))

    {:noreply, state}
  end

  @impl true
  def handle_call({:handle_packet, "Char_NEW", params, client}, _from, state) do
    %{
      name: name,
      slot: slot,
      gender: gender,
      hair_style: hair_style,
      hair_color: hair_color
    } = params

    ## Code

    {:reply, {:ok, client}, state}
  end

  def handle_call({:handle_packet, "Char_DEL", params, client}, _from, state) do
    %{slot: slot, password: password} = params

    ## Code

    {:reply, {:ok, client}, state}
  end

  def handle_call({:handle_packet, "select", params, client}, _from, state) do
    %{slot: slot} = params

    ## Code

    {:reply, {:ok, client}, state}
  end
end
