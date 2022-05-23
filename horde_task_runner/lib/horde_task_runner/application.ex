defmodule HordeTaskRunner.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = [
      gossip: [
        strategy: Cluster.Strategy.Gossip
      ]
    ]

    children = [
      {Cluster.Supervisor, [topologies, [name: TaskRunner.ClusterSupervisor]]},
      HordeTaskRunner.HordeRegistry,
      HordeTaskRunner.HordeSupervisor,
      HordeTaskRunner.NodeObserver,
      {HordeTaskRunner.TaskServer.Starter,
       [name: HordeTaskRunner.TaskServer, timeout: :timer.seconds(2)]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HordeTaskRunner.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
