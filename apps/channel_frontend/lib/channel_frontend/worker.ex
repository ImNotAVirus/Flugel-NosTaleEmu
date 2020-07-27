defmodule ChannelFrontend.Worker do
  @moduledoc """
  Documentation for ChannelFrontend.Worker
  """

  use ElvenGard.Frontend,
    packet_protocol: ChannelFrontend.PacketEncoder,
    packet_handler: ChannelFrontend.PacketHandler,
    port: Application.get_env(:channel_frontend, :port)

  import WorldManager.Channel, only: [channel: 2]

  require Logger

  alias ElvenGard.Structures.Client

  #
  # `ElvenGard.Frontend` implementation
  #

  if Mix.env() != :test do
    @impl true
    def handle_init(args) do
      port = Keyword.get(args, :port)
      Logger.info("ChannelFrontend started on port #{port}")
      register_me()
      {:ok, nil}
    end
  end

  @impl true
  def handle_connection(socket, transport) do
    client = Client.new(socket, transport, %{auth_step: :waiting_encryption_key})
    Logger.info("New connection: #{client.id}")
    {:ok, client}
  end

  @impl true
  def handle_disconnection(%Client{id: id} = client, reason) do
    Logger.info("#{id} is now disconnected (reason: #{inspect(reason)})")
    {:ok, client}
  end

  @impl true
  def handle_message(%Client{id: id} = client, message) do
    Logger.debug("New message from #{id} (len: #{byte_size(message)})")
    {:ok, client}
  end

  @impl true
  def handle_error(%Client{id: id} = client, reason) do
    Logger.error("An error occured with client #{id}: #{inspect(reason)}")
    {:ok, client}
  end

  #
  # Helpers
  #

  if Mix.env() != :test do
    @doc false
    @spec register_me() :: term
    defp register_me() do
      channel_specs = %{
        world_name: Application.get_env(:channel_frontend, :world_name, "ElvenGard"),
        ip: Application.get_env(:channel_frontend, :ip, "127.0.0.1"),
        port: Application.get_env(:channel_frontend, :port, 5000),
        max_players: Application.get_env(:channel_frontend, :max_players, 100)
      }

      {:ok, record} = WorldManager.register_channel(channel_specs)
      {world_id, channel_id} = channel(record, :id)

      {:ok, _} = WorldManager.monitor_channel(world_id, channel_id)

      Logger.info("Channel registered (#{world_id}:#{channel_id})")
    end
  end
end
