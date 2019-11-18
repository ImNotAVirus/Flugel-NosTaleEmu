defmodule WorldManager do
  @moduledoc """
  Documentation for WorldManager.
  """

  alias WorldManager.Channel

  @worker_name WorldManager.Worker

  @doc false
  @spec register_channel(map) :: Channel.t()
  def register_channel(attrs) do
    GenServer.call(@worker_name, {:register_channel, attrs})
  end

  @doc false
  @spec channels() :: [Channel.t(), ...]
  def channels() do
    GenServer.call(@worker_name, {:all_channels})
  end

  @doc false
  @spec monitor_channel(integer, integer) :: {:ok, {integer, integer}} | {:error, term}
  def monitor_channel(world_id, channel_id) do
    GenServer.call(@worker_name, {:monitor_channel, world_id, channel_id})
  end
end
