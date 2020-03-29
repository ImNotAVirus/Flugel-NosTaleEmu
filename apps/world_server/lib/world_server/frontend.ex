defmodule WorldServer.Frontend do
  @moduledoc """
  Documentation for WorldServer.Frontend
  """

  use ElvenGard.Frontend,
    packet_protocol: WorldServer.PacketEncoder,
    packet_handler: WorldServer.PacketHandler,
    port: Confex.get_env(:world_server, :port)

  require Logger

  alias ElvenGard.Structures.Client

  #
  # `ElvenGard.Frontend` implementation
  #

  if Mix.env() != :test do
    @impl true
    def handle_init(args) do
      :ok = :pg2.create({:svc, WorldFrontend})
      :ok = :pg2.join({:svc, WorldFrontend}, self())

      port = Keyword.get(args, :port)
      Logger.info("World server started on port #{port}")

      # FIXME: Nedd to rewrite a part of ElvenGard lib to fix it
      parent = self()

      Task.start(fn ->
        :timer.sleep(1000)
        register_me(parent)
      end)

      {:ok, nil}
    end
  end

  @impl true
  def handle_connection(socket, transport) do
    client = Client.new(socket, transport, %{auth_step: :waiting_session})
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
    Logger.info("New message from #{id} (len: #{byte_size(message)})")
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
    @spec register_me(pid) :: term
    defp register_me(process) do
      channel_specs = %{
        world_name: Confex.get_env(:world_server, :world_name, "ElvenGard"),
        ip: Confex.get_env(:world_server, :ip, "127.0.0.1"),
        port: Confex.get_env(:world_server, :port, 5000),
        max_players: Confex.get_env(:world_server, :max_players, 100)
      }

      %{
        world_id: world_id,
        channel_id: channel_id
      } = WorldManager.register_channel(channel_specs)

      WorldManager.monitor_channel(process, world_id, channel_id)

      Logger.info("Channel registered (#{world_id}:#{channel_id})")
    end
  end
end
