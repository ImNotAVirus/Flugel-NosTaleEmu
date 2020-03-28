defmodule WorldServer.Application do
  @moduledoc """
  Documentation for WorldServer.Application.
  """

  use Application

  require Logger

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    Logger.info("Starting #{__MODULE__}...")

    children = [
      {WorldServer.Frontend, name: WorldServer.Frontend}
    ]

    opts = [strategy: :one_for_one, name: WorldServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
