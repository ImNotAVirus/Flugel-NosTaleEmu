defmodule SessionManager.Sessions do
  @moduledoc false

  alias SessionManager.Session

  @default_ttl 120

  @doc false
  @spec get_by_username(pid, String.t()) :: Session.t() | nil
  def get_by_username(conn, username) do
    keyname = "session:#{username}"

    case Redix.command(conn, ["HGETALL", keyname]) do
      {:ok, []} ->
        nil

      {:ok, attrs} ->
        Session.from_redis_hash(attrs)
    end
  end

  @doc false
  @spec exists?(pid, String.t()) :: boolean
  def exists?(conn, username) do
    query_get = ["EXISTS", "session:#{username}"]
    Redix.command!(conn, query_get) == 1
  end

  @doc false
  @spec insert(pid, map, keyword) :: {:ok, Session.t()} | {:error, term}
  def insert(conn, attrs, opts \\ []) do
    ttl = Keyword.get(opts, :ttl, @default_ttl)
    session = create_session(conn, attrs)

    keyname = "session:#{session.username}"

    query_insert =
      session
      |> Session.to_redis_hash()
      |> List.insert_at(0, keyname)
      |> List.insert_at(0, "HMSET")

    query_expire = ["EXPIRE", keyname, ttl]

    res = Redix.transaction_pipeline(conn, [query_insert, query_expire])

    case res do
      {:ok, _} ->
        {:ok, session}

      {:error, _} = x ->
        x
    end
  end

  @doc false
  @spec update_state(pid, String.t(), atom) :: {:ok, term} | {:error, term}
  def update_state(conn, username, new_state) do
    keyname = "session:#{username}"
    query_update = ["HSET", keyname, "state", new_state]

    if exists?(conn, username) do
      Redix.command(conn, query_update)
    else
      {:error, :unknown_user}
    end
  end

  @doc false
  @spec set_monitor(pid, String.t(), reference) ::
          {:ok, term} | {:error, term} | {:error, :unknown_user}
  def set_monitor(conn, username, ref) do
    if exists?(conn, username) do
      keyname = "session_monitor#{inspect(ref)}"
      Redix.command(conn, ["SET", keyname, username])
    else
      {:error, :unknown_user}
    end
  end

  @doc false
  @spec delete_monitored(pid, reference) :: {:ok, term} | {:error, term} | {:error, :unknown_user}
  def delete_monitored(conn, ref) do
    keyname = "session_monitor#{inspect(ref)}"
    query_get = ["GET", keyname]

    case Redix.command(conn, query_get) do
      {:ok, nil} ->
        {:error, :unknown_user}

      {:ok, username} ->
        do_delete_monitored(conn, ref, username)
    end
  end

  @doc false
  @spec set_ttl(pid, String.t(), non_neg_integer | :infinity) :: {:ok, term} | {:error, term}
  def set_ttl(conn, username, :infinity) do
    query_ttl = ["PERSIST", "session:#{username}"]
    Redix.command(conn, query_ttl)
  end

  def set_ttl(conn, username, ttl) do
    query_ttl = ["EXPIRE", "session:#{username}", ttl]
    Redix.command(conn, query_ttl)
  end

  #
  # Private functions
  #

  @spec create_session(pid, map) :: Session.t()
  defp create_session(conn, attrs) do
    username = Map.fetch!(attrs, :username)
    password = Map.get(attrs, :password)
    state = Map.get(attrs, :state)
    id = next_id!(conn)

    Session.new(id, username, password, state)
  end

  @doc false
  @spec next_id!(pid) :: integer
  defp next_id!(conn) do
    Redix.command!(conn, ["INCR", "session:__count__"])
  end

  @doc false
  @spec do_delete_monitored(pid, reference, String.t()) ::
          {:ok, String.t()} | {:error, term}
  defp do_delete_monitored(conn, ref, username) do
    mon_keyname = "session_monitor#{inspect(ref)}"
    usr_keyname = "session:#{username}"

    query_del_ref = ["DEL", mon_keyname]
    query_del_user = ["DEL", usr_keyname]

    res =
      Redix.transaction_pipeline(conn, [
        query_del_ref,
        query_del_user
      ])

    case res do
      {:ok, _} ->
        {:ok, username}

      {:error, _} = x ->
        x
    end
  end
end
