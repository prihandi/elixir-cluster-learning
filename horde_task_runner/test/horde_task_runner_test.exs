defmodule HordeTaskRunnerTest do
  use ExUnit.Case
  doctest HordeTaskRunner

  test "greets the world" do
    assert HordeTaskRunner.hello() == :world
  end
end
