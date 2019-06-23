defmodule LoginServer.Actions.Auth do
  @moduledoc """
  Manage the login pipe when a client connect to the Frontend
  """

  alias ElvenGard.Structures.Client
  alias LoginServer.Crypto
  alias LoginServer.Views.AuthViews

  @type action_return :: {:ok, map} | {:halt, {:error, term}, Client.t()}

  @client_version Application.get_env(:login_server, :client_version)

  @spec player_connect(Client.t(), String.t(), map) :: action_return
  def player_connect(client, _header, params) do
    params
    |> normalize_params(client)
    |> check_version()
    |> decrypt_password()
    |> get_account_id()
    |> create_session()
    |> get_server_list()
    |> send_response()
  end

  #
  # Private function
  #

  @doc false
  @spec normalize_params(map, Client.t()) :: map
  defp normalize_params(params, client) do
    other_params = %{
      client: client,
      account_id: nil,
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
  @spec decrypt_password(action_return) :: action_return
  defp decrypt_password({:halt, _, _} = error), do: error

  defp decrypt_password({:ok, %{password: password} = params}) do
    {:ok, %{params | password: Crypto.decrypt_pass(password)}}
  end

  @doc false
  @spec get_account_id(action_return) :: action_return
  defp get_account_id({:halt, _, _} = error), do: error

  defp get_account_id({:ok, params}) do
    %{
      username: username,
      password: password,
      client: client
    } = params

    # TODO: Need to call the Auth service here
    if username == "admin" and password == "admin" do
      {:ok, %{params | account_id: 1}}
    else
      {:halt, {:error, :BAD_CREDENTIALS}, client}
    end
  end

  @doc false
  @spec create_session(action_return) :: action_return
  defp create_session({:halt, _, _} = error), do: error

  defp create_session({:ok, params}) do
    # TODO: Need to call the Auth or SessionManager service here
    session_id = 1234

    {:ok, %{params | session_id: session_id}}
  end

  @doc false
  @spec get_server_list(action_return) :: action_return
  defp get_server_list({:halt, _, _} = error), do: error

  defp get_server_list({:ok, params}) do
    # TODO: Need to call the WorldManager service here
    server_list = [
      %LoginServer.Structures.ChannelInfo{
        world_name: "NostaleEx",
        ip: "127.0.0.1",
        port: 5000,
        player_count: 0,
        max_players: 100,
        world_id: 1,
        channel_id: 1
      }
    ]

    {:ok, %{params | server_list: server_list}}
  end

  @doc false
  @spec send_response(action_return) :: action_return
  defp send_response({:halt, {:error, reason}, client} = error) do
    render = AuthViews.render(:login_error, %{error: reason})
    Client.send(client, render)
    error
  end

  defp send_response({:ok, %{client: client} = params}) do
    render = AuthViews.render(:login_succeed, params)
    Client.send(client, render)

    {:halt, {:ok, :normal}, client}
  end
end
