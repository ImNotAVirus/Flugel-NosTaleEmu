defmodule ChannelCaching.Account do
  @moduledoc """
  TODO: Documentation
  """

  @record_name :account
  @keys [:character_id, :id, :username, :password, :authority, :language]

  use Core.MnesiaHelpers, record_name: @record_name, keys: @keys

  import Record, only: [defrecord: 2]

  alias DatabaseService.Player.Account

  defrecord @record_name, @keys

  @type t ::
          record(
            :account,
            character_id: pos_integer(),
            id: pos_integer(),
            username: String.t(),
            password: String.t(),
            authority: [atom(), ...],
            language: atom()
          )

  ## Public API

  @doc """
  Create a new structure
  """
  @spec new(pos_integer(), Account.t()) :: __MODULE__.t()
  def new(character_id, %Account{} = account) do
    %Account{
      id: id,
      username: username,
      password: password,
      authority: authority,
      language: language
    } = account

    account(
      character_id: character_id,
      id: id,
      username: username,
      password: password,
      authority: authority,
      language: language
    )
  end
end
