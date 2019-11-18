defmodule SessionManager.Session do
  @moduledoc false

  @states [:logged, :in_lobby, :in_game]

  @integer_keys [:id]
  @atom_keys [:state]

  @keys [:username, :password] ++ @integer_keys ++ @atom_keys
  @enforce_keys @keys
  defstruct @keys

  @type t :: %__MODULE__{
          id: integer,
          username: String.t(),
          password: String.t(),
          state: atom
        }

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
  Return all valids states
  """
  @spec states() :: list
  def states() do
    @states
  end

  @integer_keys_str Enum.map(@integer_keys, &to_string/1)
  @atom_keys_str Enum.map(@atom_keys, &to_string/1)

  @doc false
  @spec from_redis_hash([String.t(), ...], map) :: __MODULE__.t()
  def from_redis_hash(val, acc \\ %{})
  def from_redis_hash([], acc), do: Kernel.struct(__MODULE__, acc)

  def from_redis_hash([key, val | tail], acc) when key in @integer_keys_str do
    from_redis_hash(tail, Map.put(acc, String.to_atom(key), String.to_integer(val)))
  end

  def from_redis_hash([key, val | tail], acc) when key in @atom_keys_str do
    from_redis_hash(tail, Map.put(acc, String.to_atom(key), String.to_atom(val)))
  end

  def from_redis_hash([key, val | tail], acc) do
    from_redis_hash(tail, Map.put(acc, String.to_atom(key), val))
  end

  @doc false
  @spec to_redis_hash(__MODULE__.t()) :: [String.t(), ...]
  def to_redis_hash(session) do
    session
    |> Map.from_struct()
    |> Enum.reduce([], fn {key, val}, acc -> [val, key | acc] end)
    |> Enum.reverse()
  end

  @doc """
  Returns if the given state is valid of not

  Can be use as function guard.
  """
  defmacro is_valid_state(state) do
    quote do: unquote(state) in unquote(@states)
  end
end
