defmodule HordeTaskRunner.TaskServer.Starter do
  @moduledoc """
  Module in charge of starting and monitoring  the `TaskServer`
  process, restarting it when necessary.
  """

  require Logger

  alias HordeTaskRunner.{TaskServer, HordeRegistry, HordeSupervisor}

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :temporary,
      shutdown: 500
    }
  end

  def start_link(opts) do
    name =
      opts
      |> Keyword.get(:name, TaskServer)
      |> via_tuple()

    opts = Keyword.put(opts, :name, name)

    child_spec = %{
      id: TaskServer,
      start: {TaskServer, :start_link, [opts]}
    }

    HordeSupervisor.start_child(child_spec)

    :ignore
  end

  def whereis(name \\ TaskServer) do
    name
    |> via_tuple()
    |> GenServer.whereis()
  end

  defp via_tuple(name) do
    {:via, Horde.Registry, {HordeRegistry, name}}
  end
end
