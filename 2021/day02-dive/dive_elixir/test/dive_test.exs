defmodule DiveTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog
  require Logger

  alias Dive.Command
  alias Dive.Position

  doctest Dive

  describe "#commands_input" do
    test "Given commands inputs with one movement" do
      inputs = """
      forward 5
      """

      assert Dive.commands_input(inputs) == [%Command{movement: "forward", steps: 5}]
    end

    test "Given commands inputs with multi movements" do
      inputs = """
      forward 5
      down 5
      forward 8
      up 3
      down 8
      forward 2
      """

      assert Dive.commands_input(inputs) == [
               %Command{movement: "forward", steps: 5},
               %Command{movement: "down", steps: 5},
               %Command{movement: "forward", steps: 8},
               %Command{movement: "up", steps: 3},
               %Command{movement: "down", steps: 8},
               %Command{movement: "forward", steps: 2}
             ]
    end
  end

  describe "#apply_command" do
    test "Given `forward` command on initial position" do
      assert Dive.apply_command(%Command{movement: "forward", steps: 1}, %Position{}) ==
               %Position{horizontal: 1, depth: 0, aim: 0}
    end

    test "Given `forward` command on aim not 0 position" do
      assert Dive.apply_command(%Command{movement: "forward", steps: 3}, %Position{
               horizontal: 2,
               depth: 0,
               aim: 2
             }) ==
               %Position{horizontal: 5, depth: 6, aim: 2}
    end

    test "Given `up` command" do
      assert Dive.apply_command(%Command{movement: "up", steps: 1}, %Position{
               horizontal: 0,
               depth: 2,
               aim: 3
             }) ==
               %Position{horizontal: 0, depth: 2, aim: 2}
    end

    test "Given `down` command" do
      assert Dive.apply_command(%Command{movement: "down", steps: 2}, %Position{
               horizontal: 0,
               depth: 2,
               aim: 3
             }) ==
               %Position{horizontal: 0, depth: 2, aim: 5}
    end
  end

  describe "#positions" do
    test "Given list of commands" do
      commands = [
        %Command{movement: "forward", steps: 5},
        %Command{movement: "down", steps: 5},
        %Command{movement: "forward", steps: 8},
        %Command{movement: "up", steps: 3},
        %Command{movement: "down", steps: 8},
        %Command{movement: "forward", steps: 2}
      ]

      assert Dive.position(commands) == %Position{horizontal: 15, depth: 60, aim: 10}
    end
  end

  describe "#position_from_file" do
    test "Given input file of commands" do
      with file_path <- System.get_env("INPUT_FILE_PATH", "test/data/input"),
           %Position{horizontal: horizontal, depth: depth} = position <-
             Dive.position_from_file(file_path) do
        assert position == %Position{horizontal: 2052, depth: 1_010_437, aim: 1032}
        assert horizontal * depth == 2_073_416_724
      end
    end
  end
end
