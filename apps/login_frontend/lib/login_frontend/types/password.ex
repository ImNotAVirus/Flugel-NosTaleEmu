defmodule LoginFrontend.Types.Password do
  @moduledoc """
  Define a custom type for NosTale passwords
  """

  use ElvenGard.Type

  alias LoginFrontend.Crypto

  @impl true
  def encode(_val, _opts), do: raise("unimplemented function")

  @impl true
  def decode(str, _opts) do
    decoded = Crypto.decrypt_pass(str)
    :crypto.hash(:sha512, decoded) |> Base.encode16()
  end
end
