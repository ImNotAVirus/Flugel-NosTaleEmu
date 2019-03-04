defmodule LoginServer do
  @moduledoc """
  Documentation for LoginServer.
  """

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {LoginServer.Frontend, name: LoginServer}
    ]

    opts = [strategy: :one_for_one, name: LoginServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
