defmodule LoginServer.Frontend do
  @moduledoc """
  Documentation for LoginServer.Frontend.
  """

  use ElvenGard.Frontend,
    packet_protocol: LoginServer.PacketEncoder,
    packet_handler: LoginServer.PacketHandler,
    port: Confex.get_env(:login_server, :port)

  require Logger
  alias ElvenGard.Structures.Client

  @impl true
  def handle_init(args) do
    :ok = :pg2.create({:svc, LoginFrontend})
    :ok = :pg2.join({:svc, LoginFrontend}, self())

    port = get_in(args, [:port])
    Logger.info("Login server started on port #{port}")
    {:ok, nil}
  end

  @impl true
  def handle_connection(socket, transport) do
    client = Client.new(socket, transport)
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

  @impl true
  def handle_halt_ok(%Client{id: id} = client, _args) do
    Logger.info("Client accepted: #{id}")
    {:ok, client}
  end

  @impl true
  def handle_halt_error(%Client{id: id} = client, reason) do
    Logger.warn("Client refused: #{id} - #{inspect(reason)}")
    {:ok, client}
  end
end
