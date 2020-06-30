defmodule SessionManager.Sessions do
  @moduledoc false

  import Record, only: [is_record: 1]
  import SessionManager.Session

  alias SessionManager.Session

  @type expiration_time :: :infinity | integer()

  @default_ttl 120

  ## Helpers

  @doc false
  @spec update_by_username(String.t(), atom(), any()) :: {:ok, Session.t()} | {:error, any()}
  defmacrop update_by_username(username, key, value) do
    # FIXME: Race condition (need to wrap everything into a transaction)
    quote do
      case get_by_username(unquote(username)) do
        nil ->
          {:error, :unknown_user}

        record ->
          new_session = session(record, [{unquote(key), unquote(value)}])
          write_session(new_session)
      end
    end
  end

  ## Public API

  @doc false
  @spec get_by_username(String.t()) :: Session.t() | nil
  def get_by_username(username) do
    table = Session.mnesia_table_name()
    res = :mnesia.transaction(fn -> :mnesia.read(table, username) end)

    case res do
      {:atomic, []} -> nil
      {:atomic, [attrs]} -> attrs
    end
  end

  @doc false
  @spec get_by_id(pos_integer()) :: Session.t() | nil
  def get_by_id(id) do
    table = Session.mnesia_table_name()
    res = :mnesia.transaction(fn -> :mnesia.index_read(table, id, :id) end)

    case res do
      {:atomic, []} -> nil
      {:atomic, [attrs]} -> attrs
    end
  end

  @doc false
  @spec exists?(String.t() | pos_integer()) :: boolean()
  def exists?(value) do
    table = Session.mnesia_table_name()

    query =
      cond do
        is_integer(value) -> fn -> :mnesia.index_read(table, value, :id) end
        is_binary(value) -> fn -> :mnesia.read(table, value) end
        true -> raise "`value` must be an username or a session id"
      end

    case :mnesia.transaction(query) do
      {:atomic, []} -> false
      {:atomic, [_]} -> true
    end
  end

  @doc false
  @spec insert(map, keyword) :: {:ok, Session.t()} | {:error, term}
  def insert(attrs, opts \\ []) do
    table = Session.mnesia_table_name()

    ttl = Keyword.get(opts, :ttl, @default_ttl)

    username = Map.fetch!(attrs, :username)
    password = Map.get(attrs, :password)
    state = Map.get(attrs, :state)
    expire = ttl_to_expire(ttl)

    id = :mnesia.dirty_update_counter(:auto_increment_counter, table, 1)
    session = Session.new(id, username, password, state, expire)

    write_session(session)
  end

  @doc false
  @spec update_state(String.t(), Session.state()) :: {:ok, term} | {:error, term}
  def update_state(username, new_state) when is_valid_state(new_state) do
    update_by_username(username, :state, new_state)
  end

  @doc false
  @spec set_monitor(String.t(), reference) :: {:ok, term} | {:error, term}
  def set_monitor(username, ref) do
    update_by_username(username, :monitor, ref)
  end

  @doc false
  @spec delete_monitored(reference) :: {:ok, String.t()} | {:error, term}
  def delete_monitored(ref) do
    table = Session.mnesia_table_name()

    query = fn ->
      case :mnesia.index_read(table, ref, :monitor) do
        [] ->
          {:error, :unknown_user}

        [record] ->
          expire = ttl_to_expire(@default_ttl)

          {:ok, _} =
            record
            |> session(state: :disconnected, monitor: nil, expire: expire)
            |> write_session()

          {:ok, session(record, :username)}
      end
    end

    {:atomic, res} = :mnesia.transaction(query)
    res
  end

  @doc false
  @spec set_ttl(String.t(), expiration_time) :: {:ok, term} | {:error, term}
  def set_ttl(username, ttl) do
    expire = ttl_to_expire(ttl)
    update_by_username(username, :expire, expire)
  end

  ## Private functions

  @doc false
  @spec ttl_to_expire(expiration_time) :: expiration_time
  defp ttl_to_expire(ttl) do
    case ttl do
      :infinity -> :infinity
      _ -> DateTime.to_unix(DateTime.utc_now()) + ttl
    end
  end

  @doc false
  @spec write_session(Session.t()) :: {:ok, Session.t()} | {:error, any()}
  defp write_session(mnesia_tuple) when is_record(mnesia_tuple) do
    query = fn -> :mnesia.write(mnesia_tuple) end

    case :mnesia.transaction(query) do
      {:atomic, :ok} -> {:ok, mnesia_tuple}
      {:aborted, x} -> {:error, x}
    end
  end
end
