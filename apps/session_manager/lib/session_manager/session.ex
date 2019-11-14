defmodule SessionManager.Session do
  @moduledoc false

  @states [:logged, :in_lobby, :in_game]

  @keys [:id, :username, :password, :state]
  @additional_keys [:monitor_ref]
  @enforce_keys @keys
  defstruct @keys ++ @additional_keys

  @type t :: %__MODULE__{username: String.t(), password: String.t(), state: atom}

  @doc """
  Create a new structure
  """
  @spec new(non_neg_integer, String.t(), String.t(), atom) :: __MODULE__.t()
  def new(id, username, password, state \\ :logged)
  def new(id, username, password, state) when is_nil(state), do: new(id, username, password)

  def new(id, username, password, state) when not is_nil(username) do
    %__MODULE__{
      id: id,
      username: username,
      password: password,
      state: state
    }
  end

  @doc """
  Set a new state for a session
  """
  @spec set_state(__MODULE__.t(), atom) :: __MODULE__.t()
  def set_state(session, new_state) when new_state in @states do
    %__MODULE__{session | state: new_state}
  end

  @doc """
  Set a new monitor ref for a session
  """
  @spec set_monitor_ref(__MODULE__.t(), atom) :: __MODULE__.t()
  def set_monitor_ref(session, new_monitor_ref) when is_reference(new_monitor_ref) do
    %__MODULE__{session | monitor_ref: new_monitor_ref}
  end

  @doc """
  Return all valids states
  """
  @spec states() :: list
  def states() do
    [:logged, :in_lobby, :in_game]
  end

  @doc """
  Returns if the given state is valid of not

  Can be use as function guard.
  """
  defmacro is_valid_state(state) do
    quote do: unquote(state) in unquote(@states)
  end
end
