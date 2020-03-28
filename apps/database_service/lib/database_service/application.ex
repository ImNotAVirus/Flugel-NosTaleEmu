defmodule DatabaseService.Application do
  @moduledoc false

  use Application

  require Logger

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    Logger.info("Starting #{__MODULE__}...")

    children = [
      DatabaseService.Repo
    ]

    opts = [strategy: :one_for_one, name: DatabaseService.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
