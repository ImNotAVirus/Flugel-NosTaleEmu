defmodule WorldManager do
  @moduledoc """
  Documentation for WorldManager.
  """

  alias WorldManager.Channel

  @worker_name {:svc, __MODULE__}

  @doc false
  @spec register_channel(map) :: Channel.t()
  def register_channel(attrs) do
    @worker_name
    |> :pg2.get_closest_pid()
    |> GenServer.call({:register_channel, attrs})
  end

  @doc false
  @spec channels() :: [Channel.t(), ...]
  def channels() do
    @worker_name
    |> :pg2.get_closest_pid()
    |> GenServer.call({:all_channels})
  end

  @doc false
  @spec monitor_channel(pid, integer, integer) :: {:ok, {integer, integer}} | {:error, term}
  def monitor_channel(process, world_id, channel_id) do
    @worker_name
    |> :pg2.get_closest_pid()
    |> GenServer.call({:monitor_channel, process, world_id, channel_id})
  end
end
