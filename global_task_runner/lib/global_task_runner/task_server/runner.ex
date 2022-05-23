defmodule GlobalTaskRunner.TaskServer.Runner do
  @moduledoc """
  Module which fakes deleting records from a database.
  """

  require Logger

  def execute do
    random = :rand.uniform(2_000)

    Process.sleep(random)

    Logger.info("TaskServer.Runner task with #{random} run time finished")
  end
end
