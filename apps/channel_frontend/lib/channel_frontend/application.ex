defmodule ChannelFrontend.Application do
  @moduledoc """
  Documentation for ChannelFrontend.Application.
  """

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {ChannelFrontend.Worker, name: ChannelFrontend.Worker}
    ]

    opts = [strategy: :one_for_one, name: ChannelFrontend.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
