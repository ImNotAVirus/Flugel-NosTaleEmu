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
    table = Session.mnesia_table_name()

    quote do
      query = fn ->
        case :mnesia.wread({unquote(table), unquote(username)}) do
          [] ->
            {:error, :unknown_user}

          [record] ->
            result = session(record, [{unquote(key), unquote(value)}])
            :mnesia.write(result)
            {:ok, result}
        end
      end

      {:atomic, res} = :mnesia.transaction(query)
      res
    end
  end

  ## Public API

  @doc """
  Returns all existing sessions
  """
  @spec all() :: [Session.t(), ...]
  def all() do
    match = Session.match_all_record()
    :mnesia.dirty_match_object(match)
  end

  @doc false
  @spec get_by_username(String.t()) :: Session.t() | nil
  def get_by_username(username) do
    table = Session.mnesia_table_name()

    case :mnesia.dirty_read(table, username) do
      [] -> nil
      [attrs] -> attrs
    end
  end

  @doc false
  @spec get_by_id(pos_integer()) :: Session.t() | nil
  def get_by_id(id) do
    table = Session.mnesia_table_name()

    case :mnesia.dirty_index_read(table, id, :id) do
      [] -> nil
      [attrs] -> attrs
    end
  end

  @doc false
  @spec exists?(String.t() | pos_integer()) :: boolean()
  def exists?(value) do
    table = Session.mnesia_table_name()

    result =
      cond do
        is_integer(value) -> :mnesia.dirty_index_read(table, value, :id)
        is_binary(value) -> :mnesia.dirty_read(table, value)
        true -> raise "`value` must be an username or a session id"
      end

    match?([_], result)
  end

  @doc false
  @spec insert(map, keyword) :: {:ok, Session.t()} | {:error, term()}
  def insert(attrs, opts \\ []) do
    table = Session.mnesia_table_name()

    ttl = Keyword.get(opts, :ttl, @default_ttl)

    username = Map.fetch!(attrs, :username)
    password = Map.get(attrs, :password)
    state = Map.get(attrs, :state)
    expire = ttl_to_expire(ttl)

    id = :mnesia.dirty_update_counter(:auto_increment_counter, table, 1)
    record = Session.new(id, username, password, state, expire)

    write_session(record)
  end

  @doc false
  @spec update_state(String.t(), Session.state()) :: {:ok, Session.t()} | {:error, any()}
  def update_state(username, new_state) when is_valid_state(new_state) do
    update_by_username(username, :state, new_state)
  end

  @doc false
  @spec set_monitor(String.t(), reference()) :: {:ok, Session.t()} | {:error, any()}
  def set_monitor(username, ref) do
    update_by_username(username, :monitor, ref)
  end

  @doc false
  @spec delete_monitored(reference()) :: {:ok, Session.t()} | {:error, term()}
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
  @spec set_ttl(String.t(), expiration_time()) :: {:ok, Session.t()} | {:error, any()}
  def set_ttl(username, ttl) do
    expire = ttl_to_expire(ttl)
    update_by_username(username, :expire, expire)
  end

  @doc """
  Clean expired keys
  """
  @spec clean_expired_keys(atom()) :: {:ok, [Session.t(), ...]} | {:error, any()}
  def clean_expired_keys(table) do
    curr_time = DateTime.to_unix(DateTime.utc_now())

    struct = Session.match_all_record() |> session(expire: :"$1")
    guards = [{:<, :"$1", curr_time}]
    return = [:"$_"]

    query = fn ->
      case :mnesia.select(table, [{struct, guards, return}], :write) do
        [] ->
          {:ok, []}

        [_ | _] = expired_list ->
          expired_list |> Stream.map(&elem(&1, 1)) |> Enum.each(&:mnesia.delete({table, &1}))
          {:ok, expired_list}

        invalid_term ->
          {:error, invalid_term}
      end
    end

    {:atomic, res} = :mnesia.transaction(query)
    res
  end

  ## Private functions

  @doc false
  @spec ttl_to_expire(expiration_time()) :: expiration_time()
  defp ttl_to_expire(ttl) do
    case ttl do
      :infinity -> :infinity
      _ -> DateTime.to_unix(DateTime.utc_now()) + ttl
    end
  end

  @doc false
  @spec write_session(Session.t()) :: {:ok, Session.t()} | {:error, any()}
  defp write_session(record) when is_record(record) do
    query = fn -> :mnesia.write(record) end

    case :mnesia.transaction(query) do
      {:atomic, :ok} -> {:ok, record}
      {:aborted, x} -> {:error, x}
    end
  end
end
