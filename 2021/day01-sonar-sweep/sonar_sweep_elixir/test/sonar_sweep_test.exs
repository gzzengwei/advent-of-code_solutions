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
end
