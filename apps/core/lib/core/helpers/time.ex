defmodule Core.TimeHelper do
  @moduledoc """
  TODO: Documentation for `Core.TimeHelper`.
  """

  @type expiration_time :: :infinity | integer()

  ## Public API

  @doc """
  TODO: Documentation
  """
  @spec ttl_to_expire(expiration_time()) :: expiration_time()
  def ttl_to_expire(ttl) do
    case ttl do
      :infinity -> :infinity
      _ -> DateTime.to_unix(DateTime.utc_now()) + ttl
    end
  end
end
