defmodule GlobalTaskRunner.Application do
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
      {Cluster.Supervisor, [topologies, [name: GlobalTaskRunner.ClusterSupervisor]]},
      {GlobalTaskRunner.TaskServer.Starter, [timeout: :timer.seconds(2)]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GlobalTaskRunner.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
