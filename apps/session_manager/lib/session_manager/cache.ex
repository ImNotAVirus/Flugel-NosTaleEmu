defmodule SessionManager.Cache do
  use Nebulex.Cache,
    otp_app: :session_manager,
    adapter: Nebulex.Adapters.Multilevel

  defmodule L1 do
    use Nebulex.Cache,
      otp_app: :session_manager,
      adapter: Nebulex.Adapters.Local
  end

  defmodule L2 do
    use Nebulex.Cache,
      otp_app: :session_manager,
      adapter: Nebulex.Adapters.Dist

    defmodule Primary do
      use Nebulex.Cache,
        otp_app: :session_manager,
        adapter: Nebulex.Adapters.Local
    end
  end

  defmodule JumpingHashSlot do
    @behaviour Nebulex.Adapter.HashSlot

    @doc """
    This function uses [Jump Consistent Hash](https://github.com/cabol/jchash).
    """
    @impl true
    def keyslot(key, range) do
      key
      |> :erlang.phash2()
      |> :jchash.compute(range)
    end
  end
end
