defmodule WorldManager.World do
  @moduledoc false

  @integer_keys [:id]

  @keys [:name] ++ @integer_keys
  @enforce_keys @keys
  defstruct @keys

  @type t :: %__MODULE__{
          name: String.t(),
          id: integer
        }

  @doc false
  @spec new(%{id: integer, name: String.t()}) :: __MODULE__.t()
  def new(%{id: id, name: name}) do
    __MODULE__.new(id, name)
  end

  @doc false
  @spec new(integer, String.t()) :: __MODULE__.t()
  def new(id, name) do
    %__MODULE__{
      id: id,
      name: name
    }
  end

  @integer_keys_str Enum.map(@integer_keys, &to_string/1)

  @doc false
  @spec from_redis_hash([String.t(), ...], map) :: __MODULE__.t()
  def from_redis_hash(val, acc \\ %{})
  def from_redis_hash([], acc), do: Kernel.struct(__MODULE__, acc)

  def from_redis_hash([key, val | tail], acc) when key in @integer_keys_str do
    from_redis_hash(tail, Map.put(acc, String.to_atom(key), String.to_integer(val)))
  end

  def from_redis_hash([key, val | tail], acc) do
    from_redis_hash(tail, Map.put(acc, String.to_atom(key), val))
  end

  @doc false
  @spec to_redis_hash(__MODULE__.t()) :: [String.t(), ...]
  def to_redis_hash(world) do
    world
    |> Map.from_struct()
    |> Enum.reduce([], fn {key, val}, acc -> [val, key | acc] end)
    |> Enum.reverse()
  end
end
