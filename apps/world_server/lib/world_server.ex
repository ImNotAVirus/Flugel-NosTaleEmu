defmodule WorldServer do
  @moduledoc """
  Documentation for WorldServer.
  """

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {WorldServer.Frontend, name: WorldServer.Frontend}
    ]

    opts = [strategy: :one_for_one, name: WorldServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
