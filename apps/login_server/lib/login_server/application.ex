defmodule LoginServer.Application do
  @moduledoc """
  Documentation for LoginServer.Application.
  """

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {LoginServer.Frontend, name: LoginServer.Frontend}
    ]

    opts = [strategy: :one_for_one, name: LoginServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
