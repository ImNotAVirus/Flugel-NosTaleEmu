defmodule Core.FrontendHelpers do
  @moduledoc """
  TODO: Documentation for `Core.FrontendHelpers`.
  """

  alias ElvenGard.Structures.Client

  ## Public API

  @doc """
  TODO: Documentation
  TODO: Move this function inside ElvenGard lib
  """
  @spec send_packet(Client.t(), String.t()) :: :ok
  def send_packet(%Client{} = client, message) do
    # TODO: Later use client.frontend_pid
    frontend_pid = Client.get_metadata(client, :frontend_pid)
    GenServer.cast(frontend_pid, {:send_packet, client, message})
  end
end
