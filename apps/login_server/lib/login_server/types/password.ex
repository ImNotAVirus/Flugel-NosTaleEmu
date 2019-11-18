defmodule LoginServer.Types.Password do
  @moduledoc """
  Define a custom type for NosTale passwords
  """

  use ElvenGard.Type

  alias LoginServer.Crypto

  @impl true
  def encode(_val, _opts), do: :unimplemented

  @impl true
  def decode(str, _opts) do
    Crypto.decrypt_pass(str)
  end
end
