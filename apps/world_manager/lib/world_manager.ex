defmodule WorldManager do
  @moduledoc """
  Documentation for WorldManager.
  """

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {WorldManager.Service, name: WorldManager}
    ]

    opts = [strategy: :one_for_one, name: WorldManager.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
