defmodule SwarmTaskRunner.Application do
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
      {Cluster.Supervisor, [topologies, [name: SwarmTaskRunner.ClusterSupervisor]]},
      SwarmTaskRunner.TaskServer.Supervisor,
      {SwarmTaskRunner.TaskServer.Starter, [[timeout: :timer.seconds(2)]]}
    ]

    opts = [strategy: :one_for_one, name: SwarmTaskRunner.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
