defmodule SessionManager.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    # Setup the cluster
    :ok = setup_cluster()

    # Define workers and child supervisors to be supervised
    children = [
      SessionManager.Cache.L2.Primary,
      SessionManager.Cache.L2,
      SessionManager.Cache.L1,
      SessionManager.Cache,
      SessionManager.Worker
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SessionManager.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp setup_cluster do
    :session_manager
    |> Application.get_env(:nodes, [])
    |> Enum.each(&:net_adm.ping/1)
  end
end
