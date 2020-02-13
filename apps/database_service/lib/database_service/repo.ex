defmodule DatabaseService.Repo do
  use Ecto.Repo,
    otp_app: :database_service,
    adapter: Ecto.Adapters.Postgres

  @doc """
  Dynamically loads the repository configuration from the environment variables
  """
  def init(_, config) do
    {:ok, Confex.Resolver.resolve!(config)}
  end
end
