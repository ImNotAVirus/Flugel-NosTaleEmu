defmodule SessionManager.Application do
  @moduledoc false

  use Application

  require Logger

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    Logger.info("Starting #{__MODULE__}...")

    children = [
      SessionManager.Worker
    ]

    opts = [strategy: :one_for_one, name: SessionManager.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
