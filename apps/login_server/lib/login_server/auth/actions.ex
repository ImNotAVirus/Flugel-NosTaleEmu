defmodule LoginServer.Auth.Actions do
  @moduledoc """
  Manage the login pipe when a client connect to the Frontend
  """

  alias DatabaseService.Player.{Account, Accounts}
  alias ElvenGard.Structures.Client
  alias LoginServer.Auth.Views
  alias SessionManager.Session

  @type action_return :: {:ok, map} | {:halt, {:error, term}, Client.t()}

  @client_version Application.get_env(:login_server, :client_version)

  @spec player_connect_se(Client.t(), String.t(), map) :: action_return
  def player_connect_se(client, _header, params) do
    client
    |> player_connect_base(params)
    |> send_response(:se)
  end

  @spec player_connect_gf_old(Client.t(), String.t(), map) :: action_return
  def player_connect_gf_old(client, _header, params) do
    client
    |> player_connect_base(params)
    |> send_response(:gf)
  end

  ## Private functions

  @doc false
  @spec player_connect_base(Client.t(), map) :: action_return
  defp player_connect_base(client, params) do
    params
    |> normalize_params(client)
    |> check_version()
    |> check_account()
    |> create_session()
    |> get_server_list()
  end

  @doc false
  @spec normalize_params(map, Client.t()) :: map
  defp normalize_params(params, client) do
    other_params = %{
      client: client,
      session_id: nil,
      server_list: nil
    }

    Map.merge(params, other_params)
  end

  @doc false
  @spec check_version(map) :: action_return
  defp check_version(%{version: version, client: client} = params) do
    if version == @client_version,
      do: {:ok, params},
      else: {:halt, {:error, :TOO_OLD}, client}
  end

  @doc false
  @spec check_account(action_return) :: action_return
  defp check_account({:halt, _, _} = error), do: error

  defp check_account({:ok, params}) do
    %{
      username: username,
      password: password,
      client: client
    } = params

    # TODO: Rewrite this part
    # `username` can be the real username or a session id
    case Accounts.get_by_name(username) do
      %Account{password: ^password} ->
        {:ok, params}

      _ ->
        case Integer.parse(username) do
          {session_id, ""} ->
            case SessionManager.get_by_id(session_id) do
              %Session{username: username, password: ^password} ->
                {:ok, %{params | username: username}}

              _ ->
                {:halt, {:error, :BAD_CREDENTIALS}, client}
            end

          _ ->
            {:halt, {:error, :BAD_CREDENTIALS}, client}
        end
    end
  end

  @doc false
  @spec create_session(action_return) :: action_return
  defp create_session({:halt, _, _} = error), do: error

  defp create_session({:ok, params}) do
    %{
      username: username,
      password: password,
      client: client
    } = params

    player_attrs = %{
      username: username,
      password: password
    }

    case SessionManager.register_player(player_attrs) do
      {:ok, %SessionManager.Session{id: session_id}} ->
        {:ok, %{params | session_id: session_id}}

      {:error, error} ->
        {:halt, {:error, error}, client}
    end
  end

  @doc false
  @spec get_server_list(action_return) :: action_return
  defp get_server_list({:halt, _, _} = error), do: error

  defp get_server_list({:ok, params}) do
    server_list = WorldManager.channels()
    {:ok, %{params | server_list: server_list}}
  end

  @doc false
  @spec send_response(action_return, atom) :: action_return
  defp send_response({:halt, {:error, reason}, client} = error, client_type) do
    render = Views.render(:login_error, {client_type, %{error: reason}})
    Client.send(client, render)
    error
  end

  defp send_response({:ok, %{client: client} = params}, client_type) do
    render = Views.render(:login_succeed, {client_type, params})
    Client.send(client, render)
    {:halt, {:ok, :normal}, client}
  end
end
