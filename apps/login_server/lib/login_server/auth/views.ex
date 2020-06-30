defmodule LoginServer.Auth.Views do
  @moduledoc """
  Define views (server to client packets) for the authentification part
  """

  use ElvenGard.View

  alias WorldManager.Channel

  @spec render(atom(), {:gf, map()} | {:se, map()}) :: String.t()
  def render(:login_succeed, {:se, params}) do
    %{
      session_id: session_id,
      server_list: server_list
    } = params

    "NsTeST #{session_id} #{build_server_list(server_list)}"
  end

  def render(:login_succeed, {:gf, params}) do
    %{
      username: username,
      session_id: session_id,
      server_list: server_list
    } = params

    "NsTeST #{session_id} #{username} #{build_server_list(server_list)}"
  end

  # TODO: Fix login errors for GF clients (use failc)
  def render(:login_error, {:se, %{error: error}}) do
    "fail #{error}"
  end

  def render(:login_error, {:gf, %{error: error}}) do
    "failc #{login_error_type(error)}"
  end

  ## Private functions

  @doc false
  @spec build_server_list(list()) :: String.t()
  defp build_server_list(server_list) do
    str_server_list =
      server_list
      |> Stream.map(&Channel.to_string/1)
      |> Enum.join(" ")

    "#{str_server_list} -1:-1:-1:10000.10000.1"
  end

  ## Enums

  @doc false
  @spec login_error_type(atom()) :: pos_integer()
  defp login_error_type(:TOO_OLD), do: 1
  defp login_error_type(:already_connected), do: 4
  defp login_error_type(:BAD_CREDENTIALS), do: 5
  defp login_error_type(_), do: 2
end
