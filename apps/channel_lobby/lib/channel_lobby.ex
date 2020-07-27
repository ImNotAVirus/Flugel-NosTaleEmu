defmodule ChannelLobby do
  @moduledoc """
  Documentation for `ChannelLobby`.
  """

  alias Core.GenService
  alias ElvenGard.Structures.Client

  @worker_name __MODULE__.Worker

  ## Public API

  @doc """
  TODO: Documentation
  """
  @spec call(String.t(), map(), Client.t()) :: {:ok, Client.t()} | {:error, atom()}
  def call(header, params, client) do
    GenService.call(@worker_name, header, params, client)
  end

  @doc """
  TODO: Documentation
  """
  @spec send_character_list(Client.t(), pos_integer()) :: :ok
  def send_character_list(client, account_id) do
    GenServer.cast(@worker_name, {:send_character_list, client, account_id})
  end
end
