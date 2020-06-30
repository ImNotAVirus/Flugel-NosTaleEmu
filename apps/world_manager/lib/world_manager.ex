defmodule WorldManager do
  @moduledoc """
  Documentation for WorldManager.
  """

  alias WorldManager.Channel

  @worker_name WorldManager.Worker

  @doc false
  @spec channels() :: [Channel.t(), ...]
  def channels() do
    GenServer.call(@worker_name, {:all_channels})
  end

  @doc false
  @spec register_channel(map) :: {:ok, Channel.t()} | {:error, any()}
  def register_channel(attrs) do
    GenServer.call(@worker_name, {:register_channel, attrs})
  end

  @doc false
  @spec monitor_channel(pos_integer(), pos_integer()) :: {:ok, Channel.t()} | {:error, any()}
  def monitor_channel(world_id, channel_id) do
    GenServer.call(@worker_name, {:monitor_channel, world_id, channel_id})
  end
end
