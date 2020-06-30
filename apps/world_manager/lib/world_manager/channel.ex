defmodule WorldManager.Channel do
  @moduledoc """
  TODO: Documentation

  /!\\ The channel's ID is a composite key: {world_id, channel_id}
  """

  import Record, only: [defrecord: 2]

  @record_name :channel
  @keys [:id, :world_name, :ip, :port, :max_players, :player_count, :monitor]
  defrecord @record_name, @keys

  ## Public API

  @type t ::
          record(
            :channel,
            id: {world_id :: pos_integer(), channel_id :: pos_integer()},
            world_name: String.t(),
            ip: String.t(),
            port: pos_integer(),
            max_players: pos_integer(),
            player_count: non_neg_integer(),
            monitor: reference() | nil
          )

  @doc false
  @spec new(%{
          channel_id: pos_integer(),
          world_id: pos_integer(),
          world_name: String.t(),
          ip: String.t(),
          port: pos_integer(),
          max_players: pos_integer(),
          player_count: non_neg_integer()
        }) :: __MODULE__.t()
  def new(attrs) do
    channel_id = Map.fetch!(attrs, :channel_id)
    world_id = Map.fetch!(attrs, :world_id)
    world_name = Map.fetch!(attrs, :world_name)
    ip = Map.fetch!(attrs, :ip)
    port = Map.fetch!(attrs, :port)
    max_players = Map.fetch!(attrs, :max_players)
    player_count = Map.get(attrs, :player_count, 0)

    new(channel_id, world_id, world_name, ip, port, max_players, player_count)
  end

  @doc false
  @spec new(
          pos_integer(),
          pos_integer(),
          String.t(),
          String.t(),
          pos_integer(),
          pos_integer(),
          non_neg_integer()
        ) :: __MODULE__.t()
  def new(channel_id, world_id, world_name, ip, port, max_players, player_count \\ 0) do
    channel(
      id: {world_id, channel_id},
      world_name: world_name,
      ip: ip,
      port: port,
      max_players: max_players,
      player_count: player_count
    )
  end

  @doc false
  @spec to_string(__MODULE__.t()) :: String.t()
  def to_string(record) do
    {world_id, channel_id} = channel(record, :id)
    world_name = channel(record, :world_name)
    ip = channel(record, :ip)
    port = channel(record, :port)
    max_players = channel(record, :max_players)
    player_count = channel(record, :player_count)

    population = trunc(player_count / max_players * 20)

    "#{ip}:#{port}:#{population}:#{world_id}.#{channel_id}.#{world_name}"
  end

  ## Mnesia Helpers
  ## TODO: Make `using` macro and inject theses 2 functions

  @doc false
  @spec mnesia_table_name() :: atom()
  def mnesia_table_name() do
    @record_name
  end

  @doc false
  @spec mnesia_attributes() :: [atom(), ...]
  def mnesia_attributes() do
    @keys
  end
end
