defmodule SessionManager.Sessions do
  @moduledoc false

  alias SessionManager.{Cache, Session}

  @default_ttl 120

  @doc false
  @spec get_by_username(String.t()) :: Session.t() | nil
  def get_by_username(username) do
    Cache.get(username)
  end

  @doc false
  @spec session_exists?(String.t()) :: boolean
  def session_exists?(username) do
    Cache.has_key?(username)
  end

  @doc false
  @spec insert(map, keyword) :: {:ok, Session.t()}
  def insert(attrs, opts \\ []) do
    ttl = Keyword.get(opts, :ttl, @default_ttl)
    session = create_session(attrs)

    {:ok, Cache.set(session.username, session, ttl: ttl)}
  end

  @doc false
  @spec insert_if_not_exists(map, keyword) :: {:ok, Session.t()} | {:error, :already_exists}
  def insert_if_not_exists(attrs, opts \\ []) do
    ttl = Keyword.get(opts, :ttl, @default_ttl)
    session = create_session(attrs)

    case Cache.add(session.username, session, ttl: ttl) do
      :error ->
        Cache.update_counter(:session_counter, -1)
        {:error, :already_exists}

      {:ok, x} ->
        {:ok, x}
    end
  end

  @doc false
  @spec update_state(String.t(), atom) :: {Nebulex.Cache.value(), Nebulex.Cache.return()}
  def update_state(username, new_state) do
    ttl = Cache.object_info(username, :ttl)

    Cache.get_and_update(
      username,
      fn x ->
        if x, do: {x, Session.set_state(x, new_state)}, else: :pop
      end,
      ttl: ttl
    )
  end

  @doc false
  @spec update_monitor(String.t(), reference) :: {Nebulex.Cache.value(), Nebulex.Cache.return()}
  def update_monitor(username, ref) do
    ttl = Cache.object_info(username, :ttl)

    Cache.get_and_update(
      username,
      fn x ->
        if x, do: {x, Session.set_monitor_ref(x, ref)}, else: :pop
      end,
      ttl: ttl
    )
  end

  @doc false
  @spec delete_monitor(reference) :: Session.t() | nil
  def delete_monitor(ref) do
    spec = [{{:"$1", %{monitor_ref: :"$2"}, :_, :_}, [{:==, :"$2", ref}], [:"$1"]}]
    username = spec |> Cache.stream() |> Enum.at(0)
    Cache.take(username)
  end

  @doc false
  @spec set_ttl(String.t(), non_neg_integer | :infinity) :: Session.t() | nil
  def set_ttl(username, ttl) when is_integer(ttl) or ttl == :infinity do
    Cache.get_and_update(username, fn x -> {x, x} end, ttl: ttl)
  end

  #
  # Private functions
  #

  @spec create_session(map) :: Session.t()
  defp create_session(attrs) do
    username = Map.fetch!(attrs, :username)
    password = Map.get(attrs, :password)
    state = Map.get(attrs, :state)
    id = Cache.update_counter(:session_counter)

    Session.new(id, username, password, state)
  end
end
