defmodule Core.GenService do
  @moduledoc """
  TODO: Documentation for `Core.GenService`.
  """

  alias ElvenGard.Structures.Client

  ## Public API

  @doc """
  TODO: Documentation
  """
  @spec cast(GenServer.server(), String.t(), map(), Client.t()) :: :ok
  def cast(server, header, params, client) do
    GenServer.cast(server, {:handle_packet, header, params, client})
  end

  @doc """
  TODO: Documentation
  """
  @spec call(GenServer.server(), String.t(), map(), Client.t()) ::
          {:ok, Client.t()} | {:error, atom()}
  def call(server, header, params, client) do
    GenServer.call(server, {:handle_packet, header, params, client})
  end
end
