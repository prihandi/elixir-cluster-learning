defmodule SwarmTaskRunner.TaskServer.Supervisor do
  @moduledoc """
  Supervisor for globar process TaskServer
  """

  use DynamicSupervisor

  def start_link(state) do
    DynamicSupervisor.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(opts) do
    child_spec = %{
      id: SwarmTaskRunner.TaskServer,
      start: {SwarmTaskRunner.TaskServer, :start_link, [opts]},
      restart: :transient
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end
end
