defmodule ChannelCaching do
  @moduledoc """
  Documentation for `ChannelCaching`.
  """

  alias DatabaseService.Player.{Account, Character}

  @worker_name __MODULE__.Worker

  ## Public API

  @spec init_player(Account.t(), Character.t()) :: :ok
  def init_player(%Account{} = account, %Character{} = character) do
    GenServer.call(@worker_name, {:init_player, account, character})
  end
end
