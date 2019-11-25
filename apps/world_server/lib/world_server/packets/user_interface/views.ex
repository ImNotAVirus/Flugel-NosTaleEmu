defmodule WorldServer.Packets.UserInterface.Views do
  @moduledoc """
  TODO: Documentation for WorldServer.Packets.UserInterface.Views
  """

  use ElvenGard.View

  alias WorldServer.Structures.Character

  @spec render(atom, term) :: String.t()
  def render(:info, attrs) do
    %{message: message} = attrs
    "info #{message}"
  end

  def render(:qslot, %{target: %Character{}} = attrs) do
    %{
      slot_id: slot_id,
      target: target
    } = attrs

    %Character{
      id: _id
    } = target

    # TODO: Get QuickList from a service
    # Format: window_id.tab_id.slot (not sure)
    quick_list = Enum.map(1..30, fn _ -> "7.7.-1" end)
    quick_list_str = serialize_list(quick_list, " ")

    "qslot #{slot_id} #{quick_list_str}"
  end

  #
  # Core functions
  # TODO: Move it inside 'Core' app
  #

  @spec serialize_list([term, ...], String.t()) :: String.t()
  defp serialize_list(enumerable, joiner \\ ".")
  defp serialize_list([], _), do: "-1"
  defp serialize_list([_ | _] = enumerable, joiner), do: Enum.join(enumerable, joiner)
end
