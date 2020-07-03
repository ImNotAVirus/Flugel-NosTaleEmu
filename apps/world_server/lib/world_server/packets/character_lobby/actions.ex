defmodule WorldServer.Packets.CharacterLobby.Actions do
  @moduledoc """
  Manage the login pipe when a client connect to the Frontend
  """

  alias DatabaseService.Player.Characters
  alias ElvenGard.Structures.Client
  alias WorldServer.Enums.Character, as: CharacterEnums
  alias WorldServer.Packets.CharacterLobby.Views
  alias WorldServer.Structures.Character

  @type action_return :: {:ok, map()} | {:halt, {:error, any()}, Client.t()}

  ## Public API

  @spec send_character_list(Client.t(), pos_integer()) :: any()
  def send_character_list(client, account_id) do
    character_list = Characters.all_by_account_id(account_id)

    Client.send(client, Views.render(:clist_start, nil))
    Enum.each(character_list, &Client.send(client, Views.render(:clist, &1)))
    Client.send(client, Views.render(:clist_end, nil))
  end

  @spec create_character(Client.t(), String.t(), map()) :: action_return()
  def create_character(client, _header, %{slot: slot} = params) do
    account_id = client |> Client.get_metadata(:account) |> Map.get(:id)

    case Characters.get_by_account_id_and_slot(account_id, slot) do
      nil -> do_create_character(client, account_id, params)
      _ -> Client.send(client, Views.render(:creation_failed, nil))
    end

    {:cont, client}
  end

  @spec delete_character(Client.t(), String.t(), map()) :: action_return()
  def delete_character(client, _header, params) do
    %{slot: slot, password: user_input} = params

    with account <- Client.get_metadata(client, :account),
         password <- Map.get(account, :password),
         input_hash <- hash_password(user_input),
         true <- match?(^password, input_hash),
         account_id <- Map.get(account, :id),
         {:ok, _} <- Characters.delete_by_account_id_and_slot(account_id, slot) do
      Client.send(client, Views.render(:success, nil))
      send_character_list(client, account_id)
    else
      _ -> Client.send(client, Views.render(:invalid_password, nil))
    end

    {:cont, client}
  end

  @spec select_character(Client.t(), String.t(), map) :: {:cont, Client.t()}
  def select_character(client, _header, params) do
    %{character_slot: _character_slot} = params

    # TODO: Load character from the DB Service and cache it
    character = %Character{
      id: 1,
      slot: 1,
      name: "DarkyZ",
      gender: CharacterEnums.gender_type(:female),
      hair_style: CharacterEnums.hair_style_type(:hair_style_a),
      hair_color: CharacterEnums.hair_color_type(:yellow),
      class: CharacterEnums.class_type(:wrestler),
      level: 92,
      hero_level: 25,
      job_level: 80
    }

    Client.send(client, Views.render(:ok, character))

    {:cont, client}
  end

  ## Private functions

  @doc false
  @spec do_create_character(Client.t(), pos_integer(), map()) :: any()
  defp do_create_character(client, account_id, params) do
    initial_values = %{
      account_id: account_id,
      class: CharacterEnums.class_type(:adventurer),
      faction: CharacterEnums.faction_type(:neutral),
      map_id: 1,
      map_x: :rand.uniform(3) + 77,
      map_y: :rand.uniform(4) + 113
    }

    params
    |> Map.merge(initial_values)
    |> Characters.create!()

    # TODO: Create Miniland info here

    Client.send(client, Views.render(:success, nil))
    send_character_list(client, account_id)
  end

  @doc false
  @spec hash_password(String.t()) :: String.t()
  defp hash_password(password) do
    :crypto.hash(:sha512, password) |> Base.encode16()
  end
end
