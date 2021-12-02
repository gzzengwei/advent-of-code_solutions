defmodule SonarSweepTest do
  use ExUnit.Case, async: true

  doctest SonarSweep

  describe "#measure_increases" do
    test "given empty list" do
      assert SonarSweep.measure_increases([]) == 0
    end

    test "given list of two with increase" do
      assert SonarSweep.measure_increases([1, 2]) == 1
    end

    test "given list of three with increase" do
      assert SonarSweep.measure_increases([1, 2, 3]) == 2
    end

    test "given list of two with decrease" do
      assert SonarSweep.measure_increases([2, 1]) == 0
    end

    test "given list of three with decrease" do
      assert SonarSweep.measure_increases([3, 2, 1]) == 0
    end

    test "given list of increase then decrease" do
      assert SonarSweep.measure_increases([2, 3, 2]) == 1
    end

    test "given list of decrease then increase" do
      assert SonarSweep.measure_increases([2, 1, 2]) == 1
    end

    test "given list of equal" do
      assert SonarSweep.measure_increases([1, 1]) == 0
    end

    test "given list of increase and equal" do
      assert SonarSweep.measure_increases([1, 2, 2]) == 1
    end

    test "given list of decrease and equal" do
      assert SonarSweep.measure_increases([2, 1, 1]) == 0
    end

    test "given list of decrease/decrease/equal" do
      assert SonarSweep.measure_increases([1, 2, 2, 3, 3, 2, 1]) == 2
    end
  end

  describe "#measure_from_file" do
    test "given input file path" do
      file_path = System.get_env("INPUT_FILE_PATH", "test/data/input")
      assert SonarSweep.measure_from_file(file_path) == 1482
    end
  end

  describe "#window_blocks" do
    test "given list of one" do
      assert SonarSweep.window_blocks([1]) == []
    end

    test "given list of two" do
      assert SonarSweep.window_blocks([1, 2]) == []
    end

    test "given list of three" do
      assert SonarSweep.window_blocks([1, 2, 3]) == [[1, 2, 3]]
    end

    test "given list of multiple of block size" do
      assert SonarSweep.window_blocks([1, 2, 3, 4, 5, 6]) == [
               [1, 2, 3],
               [2, 3, 4],
               [3, 4, 5],
               [4, 5, 6]
             ]
    end

    test "given list of more than block size" do
      assert SonarSweep.window_blocks([1, 2, 3, 4, 5, 6, 7]) == [
               [1, 2, 3],
               [2, 3, 4],
               [3, 4, 5],
               [4, 5, 6],
               [5, 6, 7]
             ]
    end
  end

  describe "#measure_increases_blocks" do
    test "given list of one block" do
      assert SonarSweep.measure_increases_blocks([1, 2, 3]) == 0
    end

    test "given list of blocks increase in sum" do
      assert SonarSweep.measure_increases_blocks([1, 2, 3, 4]) == 1
    end
  end

  describe "#measure_blocks_from_file" do
    test "given input file path" do
      file_path = System.get_env("INPUT_FILE_PATH", "test/data/input")
      assert SonarSweep.measure_blocks_from_file(file_path) == 1518
    end
  end
end
