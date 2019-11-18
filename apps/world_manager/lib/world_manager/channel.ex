defmodule WorldManager.Channel do
  @moduledoc false

  @integer_keys [:port, :max_players, :world_id, :channel_id]

  @keys [:world_name, :ip] ++ @integer_keys
  @additional_keys [player_count: 0]
  @enforce_keys @keys
  defstruct @keys ++ @additional_keys

  @type t :: %__MODULE__{
          world_name: String.t(),
          ip: String.t(),
          port: integer,
          player_count: integer,
          max_players: integer,
          world_id: integer,
          channel_id: integer
        }

  @doc false
  def new(attrs) do
    world_id = Map.fetch!(attrs, :world_id)
    channel_id = Map.fetch!(attrs, :channel_id)
    world_name = Map.fetch!(attrs, :world_name)
    ip = Map.fetch!(attrs, :ip)
    port = Map.fetch!(attrs, :port)
    max_players = Map.fetch!(attrs, :max_players)
    player_count = Map.get(attrs, :player_count, 0)

    %__MODULE__{
      world_id: world_id,
      channel_id: channel_id,
      world_name: world_name,
      ip: ip,
      port: port,
      player_count: player_count,
      max_players: max_players
    }
  end

  @doc false
  def new(world_id, channel_id, world_name, ip, port, max_players) do
    %__MODULE__{
      world_id: world_id,
      channel_id: channel_id,
      world_name: world_name,
      ip: ip,
      port: port,
      max_players: max_players
    }
  end

  @additional_integer_keys [:player_count]
  @all_integers_keys @integer_keys ++ @additional_integer_keys
  @integer_keys_str Enum.map(@all_integers_keys, &to_string/1)

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
  def to_redis_hash(channel) do
    channel
    |> Map.from_struct()
    |> Enum.reduce([], fn {key, val}, acc -> [val, key | acc] end)
    |> Enum.reverse()
  end

  defimpl String.Chars, for: __MODULE__ do
    def to_string(channel) do
      %{
        world_name: world_name,
        ip: ip,
        port: port,
        player_count: player_count,
        max_players: max_players,
        world_id: world_id,
        channel_id: channel_id
      } = channel

      population = trunc(player_count / max_players * 20)

      "#{ip}:#{port}:#{population}:#{world_id}.#{channel_id}.#{world_name}"
    end
  end
end
