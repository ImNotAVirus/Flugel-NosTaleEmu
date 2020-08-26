defmodule ChannelFrontend.UserInterfaceViews do
  @moduledoc """
  TODO: Documentation for ChannelFrontend.UserInterfaceViews
  """

  use ElvenGard.View

  alias Core.PacketHelpers

  @spec render(atom(), any()) :: String.t()
  def render(:info, %{message: message}) do
    "info #{message}"
  end

  def render(:qslot, %{slot_id: slot_id, quicklist: quicklist}) do
    # Format: window_id.tab_id.slot (not sure)
    "qslot #{slot_id} #{PacketHelpers.serialize_list(quicklist, " ")}"
  end

  def render(:scene, %{scene_id: scene_id}) do
    cancellable = true
    "scene #{scene_id} #{PacketHelpers.serialize_boolean(cancellable)}"
  end
end
