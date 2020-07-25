defmodule ChannelAuth.Handshake do
  @moduledoc """
  TODO: Documentation
  """

  import Record, only: [defrecord: 2]

  defrecord :handshake, [:encryption_key, :session_id, :expire]

  @type t ::
          record(
            :handshake,
            encryption_key: pos_integer(),
            session_id: pos_integer(),
            expire: pos_integer()
          )
end
