defmodule ChannelCaching do
  @moduledoc """
  Documentation for `ChannelCaching`.
  """

  alias ChannelCaching.Character, as: CharacterRecord
  alias ChannelCaching.Skill, as: SkillRecord
  alias DatabaseService.Player.{Account, Character}

  @worker_name __MODULE__.Worker

  ## Public API

  @spec init_player(Account.t(), Character.t()) :: :ok | {:error, any()}
  def init_player(%Account{} = account, %Character{} = character) do
    GenServer.call(@worker_name, {:init_player, account, character})
  end

  @spec get_character_by_id(pos_integer()) :: {:ok, CharacterRecord.t()} | {:error, any()}
  def get_character_by_id(id) do
    GenServer.call(@worker_name, {:get_character_by_id, id})
  end

  @spec get_skills_by_character_id(pos_integer()) ::
          {:ok, [SkillRecord.t(), ...]} | {:error, any()}
  def get_skills_by_character_id(id) do
    GenServer.call(@worker_name, {:get_skills_by_character_id, id})
  end
end
