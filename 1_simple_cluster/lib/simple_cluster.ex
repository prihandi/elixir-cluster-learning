defmodule SimpleCluster do
  defdelegate ping, to: LibclusterCluster.Ping
end
