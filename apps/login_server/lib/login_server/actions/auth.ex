defmodule LoginServer.Actions.Auth do
  @moduledoc """
  Manage the login pipe when a client connect to the Frontend
  """

  alias ElvenGard.Structures.Client
  alias LoginServer.Crypto

  @type action_return :: {:ok, map} | {:halt, any, Client.t()}

  @client_version Application.get_env(:login_server, :client_version)

  @spec player_connect(Client.t(), map) :: action_return
  def player_connect(client, params) do
    params
    |> merge_client(client)
    |> check_version()
    |> decrypt_password()
    |> get_account_id()
    |> create_session()
    |> get_server_list()
    |> create_res_packet()
  end

  #
  # Private function
  #

  @doc false
  @spec merge_client(map, Client.t()) :: map
  defp merge_client(params, client), do: %{params | client: client}

  @doc false
  @spec check_version(map) :: action_return
  defp check_version(%{"version" => version, "client" => client} = params) do
    if version == @client_version,
      do: {:ok, params},
      else: {:halt, {:error, :TOO_OLD}, client}
  end

  @doc false
  @spec decrypt_password(action_return) :: action_return
  defp decrypt_password({:halt, _, _} = error), do: error

  defp decrypt_password({:ok, %{"password" => password} = params}) do
    {:ok, %{params | password: Crypto.decrypt_pass(password)}}
  end

  @doc false
  @spec get_account_id(action_return) :: action_return
  defp get_account_id({:halt, _, _} = error), do: error

  defp get_account_id({:ok, params}) do
    %{
      "username" => username,
      "password" => password,
      "client" => client
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
    server_list = "127.0.0.1:5000:0:1.1.SomeTest -1:-1:-1:10000.10000.1"

    {:ok, %{params | server_list: server_list}}
  end

  @doc false
  @spec create_res_packet(action_return) :: action_return
  defp create_res_packet({:halt, _, _} = error), do: error

  defp create_res_packet({:ok, params}) do
    %{
      "session_id" => session_id,
      "server_list" => server_list,
      "client" => client
    } = params

    res_packet = "NsTeST #{session_id} #{server_list}"
    {:halt, {:ok, res_packet}, client}
  end
end
