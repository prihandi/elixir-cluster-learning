defmodule GlobalTaskRunner.TaskServer.Starter do
  @moduledoc """
  Start the task server globally and restart if necessary
  """

  use GenServer
  require Logger

  alias GlobalTaskRunner.TaskServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl GenServer
  def init(opts) do
    pid = start_and_monitor(opts)

    {:ok, {pid, opts}}
  end

  @impl GenServer
  def handle_info({:DOWN, _, :process, pid, _reason}, {pid, opts} = state) do
    log("process down, restarting... #{inspect(state)}")

    {:noreply, {start_and_monitor(opts), opts}}
  end

  defp start_and_monitor(opts) do
    log("(re)starting #{inspect(opts)}...")

    pid =
      case GenServer.start_link(TaskServer, opts, name: {:global, TaskServer}) do
        {:ok, pid} ->
          pid

        {:error, {:already_started, pid}} ->
          log("...already started!")
          pid
      end

    Process.monitor(pid)

    log("monitoring #{inspect(pid)}...")

    pid
  end

  defp log(text) do
    Logger.info("----[#{node()}] TaskServer.Starter #{text}")
  end
end
