defmodule SessionManager.Session do
  @moduledoc false

  @keys [:username, :password, :state]
  @enforce_keys @keys
  defstruct @keys

  @type t :: %__MODULE__{username: String.t(), password: String.t(), state: atom}

  @doc """
  Create a new structure
  """
  @spec new(String.t(), String.t(), atom) :: __MODULE__.t()
  def new(username, password, state \\ :logged)
  def new(username, password, state) when is_nil(state), do: new(username, password)

  def new(username, password, state) when not is_nil(username) do
    %__MODULE__{
      username: username,
      password: password,
      state: state
    }
  end
end
