defmodule SwarmTaskRunnerTest do
  use ExUnit.Case
  doctest SwarmTaskRunner

  test "greets the world" do
    assert SwarmTaskRunner.hello() == :world
  end
end
