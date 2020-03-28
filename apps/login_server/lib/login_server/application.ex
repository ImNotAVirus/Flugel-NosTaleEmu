defmodule LoginServer.Application do
  @moduledoc """
  Documentation for LoginServer.Application.
  """

  use Application

  require Logger

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    Logger.info("Starting #{__MODULE__}...")

    children = [
      {LoginServer.Frontend, name: LoginServer.Frontend}
    ]

    opts = [strategy: :one_for_one, name: LoginServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
