defmodule GlobalTaskRunner.TaskServer do
  @moduledoc """
  Fake module that running some tasks.
  """

  use GenServer
  require Logger

  alias __MODULE__.Runner

  @default_timeout :timer.seconds(4)

  @impl GenServer
  def init(args \\ []) do
    timeout = Keyword.get(args, :timeout, @default_timeout)

    schedule(timeout)

    {:ok, timeout}
  end

  @impl GenServer
  def handle_info(:execute, timeout) do
    log("running a task...")

    Task.start(Runner, :execute, [])

    schedule(timeout)

    {:noreply, timeout}
  end

  defp schedule(timeout) do
    log("scheduling for #{timeout}ms...")

    Process.send_after(self(), :execute, timeout)
  end

  defp log(text) do
    Logger.info("----[#{node()}] TaskServer #{text}")
  end
end
