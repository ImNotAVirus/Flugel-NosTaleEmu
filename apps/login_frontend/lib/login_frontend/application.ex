defmodule LoginFrontend.Application do
  @moduledoc """
  Documentation for LoginFrontend.Application.
  """

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {LoginFrontend.Worker, name: LoginFrontend.Worker}
    ]

    opts = [strategy: :one_for_one, name: LoginFrontend.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
