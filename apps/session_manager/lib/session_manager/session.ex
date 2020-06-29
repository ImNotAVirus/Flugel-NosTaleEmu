defmodule SessionManager.Session do
  @moduledoc false

  @mnesia_table_name :session
  @states [:logged, :in_lobby, :in_game, :disconnected]

  @enforce_keys [:username, :id, :password, :state, :expire]
  @additional_keys [:monitor]
  @all_keys @enforce_keys ++ @additional_keys
  defstruct @all_keys

  @type state :: :logged | :in_lobby | :in_game

  @type t :: %__MODULE__{
          id: integer,
          username: String.t(),
          password: String.t(),
          state: state,
          expire: pos_integer(),
          monitor: reference()
        }

  @doc """
  Create a new structure
  """
  @spec new(pos_integer(), String.t(), String.t(), atom(), pos_integer()) :: __MODULE__.t()
  def new(id, username, password, state \\ :logged, expire \\ :infinity) do
    %__MODULE__{
      id: id,
      username: username,
      password: password,
      state: state || :logged,
      expire: expire
    }
  end

  @doc """
  Return all valids states
  """
  @spec states() :: list
  def states() do
    @states
  end

  @doc false
  @spec mnesia_table_name() :: atom()
  def mnesia_table_name() do
    @mnesia_table_name
  end

  @doc false
  @spec mnesia_attributes() :: [atom(), ...]
  def mnesia_attributes() do
    @all_keys
  end

  @doc false
  def from_mnesia_value({table_name, username, id, password, state, expire, monitor})
      when table_name == @mnesia_table_name do
    %__MODULE__{
      id: id,
      username: username,
      password: password,
      state: state,
      expire: expire,
      monitor: monitor
    }
  end

  @doc false
  def to_mnesia_value(%__MODULE__{} = session) do
    %__MODULE__{
      id: id,
      username: username,
      password: password,
      state: state,
      expire: expire,
      monitor: monitor
    } = session

    {@mnesia_table_name, username, id, password, state, expire, monitor}
  end

  @doc """
  Returns if the given state is valid of not

  Can be use as function guard.
  """
  defmacro is_valid_state(state) do
    quote do: unquote(state) in unquote(@states)
  end
end
