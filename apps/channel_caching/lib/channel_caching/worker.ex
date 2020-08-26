defmodule ChannelCaching.Worker do
  @moduledoc false

  use GenServer

  require Logger

  alias ChannelCaching.Account, as: AccountRecord
  alias ChannelCaching.Character, as: CharacterRecord
  alias DatabaseService.Player.{Account, Character}

  @doc false
  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  ## Genserver behaviour

  @impl true
  def init(_) do
    Logger.info("ChannelCaching starting...")
    {:ok, nil, {:continue, :init_mnesia}}
  end

  @impl true
  def handle_continue(:init_mnesia, nil) do
    :ok = :mnesia.start()

    account_table_name = AccountRecord.mnesia_table_name()
    account_attributes = AccountRecord.mnesia_attributes()
    {:atomic, :ok} = :mnesia.create_table(account_table_name, attributes: account_attributes)
    {:atomic, :ok} = :mnesia.add_table_index(account_table_name, :id)
    {:atomic, :ok} = :mnesia.add_table_index(account_table_name, :username)

    character_table_name = CharacterRecord.mnesia_table_name()
    character_attributes = CharacterRecord.mnesia_attributes()
    {:atomic, :ok} = :mnesia.create_table(character_table_name, attributes: character_attributes)
    {:atomic, :ok} = :mnesia.add_table_index(character_table_name, :name)

    Logger.info("ChannelCaching started")
    {:noreply, nil}
  end

  @impl true
  def handle_call({:init_player, %Account{} = account, %Character{} = character}, _from, state) do
    %Character{id: character_id} = character

    with {:ok, _} <- write_account(character_id, account),
         {:ok, _} <- write_character(character) do
      {:reply, :ok, state}
    else
      {:error, _} = e -> {:reply, e, state}
      e -> {:reply, {:error, e}, state}
    end
  end

  ## Private function

  @typep record :: tuple()

  @doc false
  @spec write_record(record()) :: {:ok, record()} | {:error, any()}
  defp write_record(record) do
    query = fn -> :mnesia.write(record) end

    case :mnesia.transaction(query) do
      {:atomic, :ok} -> {:ok, record}
      {:aborted, x} -> {:error, x}
    end
  end

  @doc false
  @spec write_account(pos_integer(), Account.t()) :: {:ok, AccountRecord.t()} | {:error, any()}
  defp write_account(character_id, %Account{} = account) do
    record = AccountRecord.new(character_id, account)
    write_record(record)
  end

  @doc false
  @spec write_character(Character.t()) :: {:ok, CharacterRecord.t()} | {:error, any()}
  defp write_character(%Character{} = character) do
    record = CharacterRecord.new(character)
    write_record(record)
  end
end
