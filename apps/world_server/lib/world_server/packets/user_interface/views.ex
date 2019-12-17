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

  def render(:scene, attrs) do
    %{scene_id: scene_id} = attrs

    cancellable = true
    cancellable_str = serialize_boolean(cancellable)

    "scene #{scene_id} #{cancellable_str}"
  end

  #
  # Core functions
  # TODO: Move it inside 'Core' app
  #

  @spec serialize_list([term, ...], String.t()) :: String.t()
  defp serialize_list(enumerable, joiner \\ ".")
  defp serialize_list([], _), do: "-1"
  defp serialize_list([_ | _] = enumerable, joiner), do: Enum.join(enumerable, joiner)

  @spec serialize_boolean(boolean) :: String.t()
  defp serialize_boolean(bool), do: if(bool, do: "1", else: "0")
end
