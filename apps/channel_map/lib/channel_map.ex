defmodule ChannelMap do
  @moduledoc """
  Documentation for `ChannelMap`.
  """

  import ChannelCaching.Character, only: [character: 2, is_character: 1]

  alias ChannelMap.Views
  alias Core.FrontendHelpers

  @doc """
  TODO: Documentation
  """
  def change_map(character_id, new_map_id, new_map_x, new_map_y) do
    frontend_pid = nil
    character = nil

    :ok
  end

  @doc """
  TODO: Documentation
  """
  @spec setup_player_map(tuple(), pid() | nil) :: :ok
  def setup_player_map(char_record, frontend_pid \\ nil)

  def setup_player_map(char_record, nil) when is_character(char_record) do
    character_id = character(char_record, :id)
    frontend_pid = ChannelCaching.frontend_pid_from_char_id(character_id)
    setup_player_map(char_record, frontend_pid)
  end

  def setup_player_map(char_record, frontend_pid)
      when is_character(char_record) and is_pid(frontend_pid) do
    character_id = character(char_record, :id)
    map_id = character(char_record, :map_id)
    map_x = character(char_record, :map_x)
    map_y = character(char_record, :map_y)

    state = %{
      id: 1,
      music: 1,
      # 1 = base & 0 = instanciated ?
      type: 1
    }

    args = %{target: char_record, state: state}

    FrontendHelpers.send_packet(frontend_pid, Views.render(:at, args))
    FrontendHelpers.send_packet(frontend_pid, Views.render(:c_map, state))
  end
end
