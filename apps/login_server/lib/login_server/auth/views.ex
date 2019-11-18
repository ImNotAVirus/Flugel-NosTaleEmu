defmodule LoginServer.Auth.Views do
  @moduledoc """
  Define views (server to client packets) for the authentification part
  """

  use ElvenGard.View

  @spec render(atom, map) :: String.t()
  def render(:login_succeed, params) do
    %{
      session_id: session_id,
      server_list: server_list
    } = params

    endl = "-1:-1:-1:10000.10000.1"

    str_server_list =
      server_list
      |> Stream.map(&to_string/1)
      |> Enum.join(" ")

    "NsTeST #{session_id} #{str_server_list} #{endl}"
  end

  def render(:login_error, %{error: error}) when is_binary(error) do
    "fail #{error}"
  end

  def render(:login_error, %{error: error}) do
    render(:login_error, %{error: to_string(error)})
  end
end
