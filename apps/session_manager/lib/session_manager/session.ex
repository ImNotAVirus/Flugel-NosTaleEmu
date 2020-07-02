defmodule SessionManager.Session do
  @moduledoc false

  import Record, only: [defrecord: 2]

  @states [:logged, :in_lobby, :in_game, :disconnected]

  @record_name :session
  @keys [:username, :id, :password, :state, :expire, :monitor]
  defrecord @record_name, @keys

  @type state :: :logged | :in_lobby | :in_game | :disconnected

  @type t ::
          record(
            :session,
            id: pos_integer(),
            username: String.t(),
            password: String.t(),
            state: state,
            expire: :infinity | pos_integer(),
            monitor: reference() | nil
          )

  ## Public API

  @doc """
  Create a new structure
  """
  @spec new(pos_integer(), String.t(), String.t(), state, :infinity | pos_integer()) ::
          __MODULE__.t()
  def new(id, username, password, state \\ :logged, expire \\ :infinity) do
    session(
      id: id,
      username: username,
      password: password,
      state: state || :logged,
      expire: expire
    )
  end

  @doc """
  Return all valids states
  """
  @spec states() :: list
  def states() do
    @states
  end

  ## Mnesia Helpers
  ## TODO: Make `using` macro and inject theses helpers

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

  @doc false
  defmacro match_all_record() do
    match = @keys |> Enum.map(&{&1, :_})

    quote do
      unquote(@record_name)(unquote(match))
    end
  end

  @doc """
  Returns if the given state is valid of not

  Can be use as function guard.
  """
  defmacro is_valid_state(state) do
    quote do: unquote(state) in unquote(@states)
  end
end
