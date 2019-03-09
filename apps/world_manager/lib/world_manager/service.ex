defmodule ElvenGard.Services.GenericService do
  @moduledoc false

  @doc false
  defmacro __using__(_) do
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
        {:ok, nil}
      end

    end
  end
end

defmodule WorldManager.Service do
  @moduledoc """
  Documentation for LoginServer.Service.
  """

  use ElvenGard.Services.GenericService
end
