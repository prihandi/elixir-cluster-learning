defmodule SwarmTaskRunner.TaskServer.Starter do
  use GenServer
  require Logger

  alias SwarmTaskRunner.TaskServer
  alias SwarmTaskRunner.TaskServer.Supervisor, as: TaskServerSupervisor

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl GenServer
  def init(opts) do
    {:ok, opts, {:continue, {:start_and_monitor, 1}}}
  end

  @impl GenServer
  def handle_continue({:start_and_monitor, retry}, opts) do
    log("starting and monitoring #{retry}: #{inspect(opts)}...")

    case Swarm.whereis_or_register_name(
           TaskServer,
           TaskServerSupervisor,
           :start_child,
           [opts]
         ) do
      {:ok, pid} ->
        Process.monitor(pid)

        {:noreply, {pid, opts}}

      other ->
        log("error while fetching or registering process: #{inspect(other)}")

        Process.sleep(500)
        {:noreply, opts, {:continue, {:start_and_monitor, retry + 1}}}
    end
  end

  @impl GenServer
  def handle_info({:DOWN, _, :process, pid, _reason}, {pid, opts}) do
    log("process down, restarting... #{inspect(opts)}")

    {:noreply, opts, {:continue, {:start_and_monitor, 1}}}
  end

  defp log(text) do
    Logger.info("----[#{node()}] TaskServer.Starter #{text}")
  end
end
