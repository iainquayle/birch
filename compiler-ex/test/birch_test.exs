defmodule BirchTest do
  use ExUnit.Case
  doctest Birch 

  test "greets the world" do
    assert Birch.hello() == :world
  end
end
