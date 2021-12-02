defmodule DiveTest do
  use ExUnit.Case
  doctest Dive

  test "greets the world" do
    assert Dive.hello() == :world
  end
end
