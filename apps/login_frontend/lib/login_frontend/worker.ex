defmodule LoginFrontend.Worker do
  @moduledoc """
  Documentation for LoginFrontend.Worker.
  """

  use ElvenGard.Frontend,
    packet_protocol: LoginFrontend.PacketEncoder,
    packet_handler: LoginFrontend.PacketHandler,
    port: Application.get_env(:login_frontend, :port)

  require Logger
  alias ElvenGard.Structures.Client

  @impl true
  def handle_init(args) do
    port = get_in(args, [:port])
    Logger.info("LoginFrontend started on port #{port}")
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
    Logger.debug("New message from #{id} (len: #{byte_size(message)})")
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
