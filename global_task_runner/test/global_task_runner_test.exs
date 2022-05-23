defmodule GlobalTaskRunnerTest do
  use ExUnit.Case
  doctest GlobalTaskRunner

  test "greets the world" do
    assert GlobalTaskRunner.hello() == :world
  end
end
