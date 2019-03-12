defmodule WorldServer.Frontend do
  @moduledoc """
  Documentation for WorldServer.Frontend
  """

  use ElvenGard.Helpers.Frontend,
    packet_encoder: WorldServer.PacketEncoder,
    packet_handler: WorldServer.PacketHandler,
    port: Application.get_env(:world_server, :port)

  require Logger

  alias ElvenGard.Service
  alias ElvenGard.Structures.Client

  #
  # `ElvenGard.Helpers.Frontend` implementation
  #

  @impl true
  def handle_init(args) do
    port = Keyword.get(args, :port)
    Logger.info("World server started on port #{port}")

    # Register in world_manager after 1 secs (ensure world_manager is started)
    # TODO: Clean that
    Process.send_after(self(), :register_me, 1_000)

    {:ok, nil}
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
  # `GenServer` implementation
  #

  @impl true
  def handle_info(:register_me, state) do
    :ok = Service.cast(:world_manager, {:add_world, self()})
    {:noreply, state}
  end
end
