defmodule ElvenGard.Services.GenericService do
  @moduledoc false

  @doc false
  defmacro __using__(opts) do
    state_model = Keyword.get(opts, :state_model)

    quote do
      use GenServer

      #
      # GenServer implementation
      #

      @doc false
      def start_link(opts) do
        {:ok, _pid} = GenServer.start_link(__MODULE__, nil)
      end

      def init(_) do
        name = :world_manager
        attributes = unquote(state_model).attributes()

        :pg2.create(name)
        :ok = :pg2.join(name, self())

        Process.flag(:trap_exit, true)

        {:ok, nil}
      end

    end
  end
end

defmodule WorldManager.StateModel do
  @moduledoc false

  def attributes() do
    []
  end


end

defmodule WorldManager.Service do
  @moduledoc """
  Documentation for LoginServer.Service.
  """

  use ElvenGard.Services.GenericService,
    state_model: WorldManager.StateModel

  @impl true
  def handle_info({:add_world, world}, state) do
    IO.inspect("Add World with pid #{inspect(world)}")
    Process.monitor(world)
    {:noreply, state}
  end

  @impl true
  def handle_info({:DOWN, _id, :process, pid, _reason}, state) do
    IO.inspect("Remove World with pid #{inspect(pid)}")
    {:noreply, state}
  end
end
