defmodule LibclusterCluster.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = [
      epmd_native: [
        strategy: Cluster.Strategy.Epmd,
        config: [hosts: [:"n1@127.0.0.1", :"n2@127.0.0.1"]]
      ]
    ]

    # topologies = [
    #   gossip: [
    #     strategy: Cluster.Strategy.Gossip
    #   ]
    # ]

    children = [
      {Cluster.Supervisor, [topologies, [name: LibclusterCluster.ClusterSupervisor]]},
      LibclusterCluster.NodeObserver,
      LibclusterCluster.Ping
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LibclusterCluster.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
