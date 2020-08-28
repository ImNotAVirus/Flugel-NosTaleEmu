defmodule ChannelCaching.Worker do
  @moduledoc false

  use GenServer

  require Logger

  import ChannelCaching.CharacterSkill, only: [character_skill: 2]
  import ChannelCaching.CharacterFrontend, only: [character_frontend: 2]

  alias ChannelCaching.Account, as: AccountRecord
  alias ChannelCaching.Character, as: CharacterRecord
  alias ChannelCaching.CharacterSkill, as: CharacterSkillRecord
  alias ChannelCaching.CharacterFrontend, as: CharacterFrontendRecord
  alias DatabaseService.Player.Character

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
    account_attrs = AccountRecord.mnesia_attributes()
    {:atomic, :ok} = :mnesia.create_table(account_table_name, attributes: account_attrs)
    {:atomic, :ok} = :mnesia.add_table_index(account_table_name, :id)
    {:atomic, :ok} = :mnesia.add_table_index(account_table_name, :username)

    character_table_name = CharacterRecord.mnesia_table_name()
    character_attrs = CharacterRecord.mnesia_attributes()
    {:atomic, :ok} = :mnesia.create_table(character_table_name, attributes: character_attrs)
    {:atomic, :ok} = :mnesia.add_table_index(character_table_name, :name)

    cskill_table_name = CharacterSkillRecord.mnesia_table_name()
    cskill_attrs = CharacterSkillRecord.mnesia_attributes()
    {:atomic, :ok} = :mnesia.create_table(cskill_table_name, attributes: cskill_attrs, type: :bag)

    cfrontend_table_name = CharacterFrontendRecord.mnesia_table_name()
    cfrontend_attrs = CharacterFrontendRecord.mnesia_attributes()
    {:atomic, :ok} = :mnesia.create_table(cfrontend_table_name, attributes: cfrontend_attrs)

    Logger.info("ChannelCaching started")
    {:noreply, nil}
  end

  @impl true
  def handle_call({:init_player, account, character, frontend_pid}, _from, state) do
    %Character{id: character_id} = character

    acc_record = AccountRecord.new(character_id, account)
    char_record = CharacterRecord.new(character)
    front_record = CharacterFrontendRecord.new(character_id, frontend_pid)

    # TODO: Get from database
    skill_vnums = [200, 201, 209]

    query = fn ->
      :mnesia.write(acc_record)
      :mnesia.write(char_record)
      :mnesia.write(front_record)

      Enum.each(skill_vnums, fn vnum ->
        skill_record = CharacterSkillRecord.new(character_id, vnum)
        :mnesia.write(skill_record)
      end)
    end

    {:reply, transaction(query), state}
  end

  @impl true
  def handle_call({:get_character_by_id, character_id}, _from, state) do
    character_table_name = CharacterRecord.mnesia_table_name()

    case :mnesia.dirty_read({character_table_name, character_id}) do
      [record] -> {:reply, {:ok, record}, state}
      _ -> {:reply, {:error, :invalid_id}, state}
    end
  end

  @impl true
  def handle_call({:get_skills_by_character_id, character_id}, _from, state) do
    cskill_table_name = CharacterSkillRecord.mnesia_table_name()

    case :mnesia.dirty_read({cskill_table_name, character_id}) do
      [] -> {:reply, {:error, :invalid_id}, state}
      skills -> {:reply, {:ok, Enum.map(skills, &character_skill(&1, :vnum))}, state}
    end
  end

  @impl true
  def handle_call({:frontend_pid_from_char_id, character_id}, _from, state) do
    cfrontend_table_name = CharacterFrontendRecord.mnesia_table_name()

    case :mnesia.dirty_read({cfrontend_table_name, character_id}) do
      [frontend_record] -> {:reply, {:ok, character_frontend(frontend_record, :pid)}, state}
      _ -> {:reply, {:error, :invalid_id}, state}
    end
  end

  # Private functions

  @doc false
  @spec transaction((... -> any())) :: :ok | {:error, any()}
  defp transaction(query) do
    case :mnesia.transaction(query) do
      {:atomic, :ok} -> :ok
      {:aborted, x} -> {:error, x}
    end
  end
end
