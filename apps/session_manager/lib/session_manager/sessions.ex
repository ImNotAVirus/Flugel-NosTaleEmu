defmodule SessionManager.Sessions do
  @moduledoc false

  alias SessionManager.{Cache, Session}

  @default_ttl 120

  @doc false
  @spec get_by_username(String.t()) :: {:ok, Session.t()} | {:error, :not_found}
  def get_by_username(username) do
    case Cache.get(username) do
      nil ->
        {:error, :not_found}

      x ->
        {:ok, x}
    end
  end

  @doc false
  @spec session_exists?(String.t()) :: boolean
  def session_exists?(username) do
    Cache.get(username) != nil
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
