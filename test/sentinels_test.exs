defmodule SentinelsTest do
  use ExUnit.Case
  doctest Sentinels

  test "greets the world" do
    assert Sentinels.hello() == :world
  end
end
