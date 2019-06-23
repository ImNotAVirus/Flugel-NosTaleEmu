defmodule LoginServer.Structures.ChannelInfo do
  @moduledoc false

  @keys [:world_name, :ip, :port, :player_count, :max_players, :world_id, :channel_id]
  @enforce_keys @keys
  defstruct @keys

  defimpl String.Chars, for: __MODULE__ do
    def to_string(channel_info) do
      %{
        world_name: world_name,
        ip: ip,
        port: port,
        player_count: player_count,
        max_players: max_players,
        world_id: world_id,
        channel_id: channel_id
      } = channel_info

      population = trunc(player_count / max_players * 20)

      "#{ip}:#{port}:#{population}:#{world_id}.#{channel_id}.#{world_name}"
    end
  end
end
