defmodule DatabaseService.Bitfields do
  @moduledoc false

  import EctoBitfield

  #
  # GameMaster: can ban, kick, mute, customs commands, etc....
  # Administrator: can use "system" commands like kill services, reboots servers, ...
  #
  defbitfield AuthorityType, [:game_master, :administrator]
end
