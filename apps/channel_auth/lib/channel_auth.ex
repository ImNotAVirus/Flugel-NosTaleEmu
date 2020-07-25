defmodule ChannelAuth do
  @moduledoc """
  TODO: Documentation for `ChannelAuth`.
  """

  alias Core.GenService

  @worker_name __MODULE__.Worker

  ## Public API

  @doc """
  TODO: Documentation
  """
  @spec call(String.t(), map(), Client.t()) :: {:ok, Client.t()} | {:error, atom()}
  def call(header, params, client) do
    GenService.call(@worker_name, header, params, client)
  end
end
