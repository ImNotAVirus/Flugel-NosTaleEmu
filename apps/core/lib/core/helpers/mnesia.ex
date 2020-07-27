defmodule Core.MnesiaHelpers do
  @moduledoc """
  TODO: Documentation for `Core.MnesiaHelpers`.
  """

  ## Public API

  @doc false
  defmacro __using__(opts) do
    record_name = Keyword.get(opts, :record_name)
    keys = Keyword.get(opts, :keys)

    if record_name == nil, do: raise_error!("record_name")
    if keys == nil, do: raise_error!("keys")

    quote do
      def mnesia_table_name(), do: unquote(record_name)

      def mnesia_attributes(), do: unquote(keys)

      defmacro match_all_record() do
        match = unquote(keys) |> Enum.map(&{&1, :_})
        record_name = unquote(record_name)

        quote do
          unquote(record_name)(unquote(match))
        end
      end
    end
  end

  ## Private functions

  @doc false
  @spec raise_error!(String.t()) :: no_return()
  defp raise_error!(attribute_name) do
    raise "you must define the `#{attribute_name}` attribute.

    ## Example:

      use #{__MODULE__}, record_name: :session, keys: [:id, :name]
    "
  end
end
