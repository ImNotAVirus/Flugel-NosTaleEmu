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
  @spec send_packet(Client.t() | pid(), String.t()) :: :ok
  def send_packet(frontend_pid, message) when is_pid(frontend_pid) do
    GenServer.cast(frontend_pid, {:send_packet, message})
  end

  def send_packet(%Client{} = client, message) do
    # TODO: Later use client.frontend_pid
    client
    |> Client.get_metadata(:frontend_pid)
    |> send_packet(message)
  end
end
