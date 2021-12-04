defmodule SubmarineTest do
  use ExUnit.Case
  doctest Submarine

  describe "#sanitize_input" do
    test "convert inputs to list of char list" do
      inputs = """
      00100
      11110
      10110
      10111
      10101
      01111
      00111
      11100
      10000
      11001
      00010
      01010
      """

      assert Submarine.sanitize_input(inputs) == [
               ["0", "0", "1", "0", "0"],
               ["1", "1", "1", "1", "0"],
               ["1", "0", "1", "1", "0"],
               ["1", "0", "1", "1", "1"],
               ["1", "0", "1", "0", "1"],
               ["0", "1", "1", "1", "1"],
               ["0", "0", "1", "1", "1"],
               ["1", "1", "1", "0", "0"],
               ["1", "0", "0", "0", "0"],
               ["1", "1", "0", "0", "1"],
               ["0", "0", "0", "1", "0"],
               ["0", "1", "0", "1", "0"]
             ]
    end
  end

  describe "#rotae_lists" do
    test "Given list of multi list" do
      lists = [
        ["0", "0", "1", "0", "0"],
        ["1", "1", "1", "1", "0"],
        ["1", "0", "1", "1", "0"],
        ["1", "0", "1", "1", "1"],
        ["1", "0", "1", "0", "1"],
        ["0", "1", "1", "1", "1"],
        ["0", "0", "1", "1", "1"],
        ["1", "1", "1", "0", "0"],
        ["1", "0", "0", "0", "0"],
        ["1", "1", "0", "0", "1"],
        ["0", "0", "0", "1", "0"],
        ["0", "1", "0", "1", "0"]
      ]

      assert Submarine.rotae_lists(lists) == [
               ["0", "1", "1", "1", "1", "0", "0", "1", "1", "1", "0", "0"],
               ["0", "1", "0", "0", "0", "1", "0", "1", "0", "1", "0", "1"],
               ["1", "1", "1", "1", "1", "1", "1", "1", "0", "0", "0", "0"],
               ["0", "1", "1", "1", "0", "1", "1", "0", "0", "0", "1", "1"],
               ["0", "0", "0", "1", "1", "1", "1", "0", "0", "1", "0", "0"]
             ]
    end
  end

  describe "#element_occurrences" do
    test "Given a list" do
      list = ["0", "0", "0", "1", "1", "1", "1", "0", "0", "1", "0", "0"]

      assert Submarine.element_occurrences(list) == %{"0" => 7, "1" => 5}
    end
  end

  describe "#min_max_list" do
    test "Given a map of pair of count returns tuple in order" do
      assert Submarine.min_max_list(%{"0" => 5, "1" => 7}) == {{"0", 5}, {"1", 7}}
      assert Submarine.min_max_list(%{"0" => 9, "1" => 7}) == {{"1", 7}, {"0", 9}}
    end
  end

  describe "#gamma_rate" do
    setup do
      {:ok, inputs: inputs(), file_inputs: file_inputs()}
    end

    test "get gamma rate from input of one" do
      assert Submarine.gamma_rate("00100") == 4
    end

    test "get gamma rate from multiple inputs by lines", %{inputs: inputs} do
      assert Submarine.gamma_rate(inputs) == 22
    end

    test "get gamma rate from file", %{file_inputs: file_inputs} do
      assert Submarine.gamma_rate(file_inputs) == 941
    end
  end

  describe "#epsilon_rate" do
    setup do
      {:ok, inputs: inputs(), file_inputs: file_inputs()}
    end

    test "get epsilon rate from input of one" do
      assert Submarine.epsilon_rate("10100") == 20
    end

    test "get epsilon rate from multiple inputs by lines", %{inputs: inputs} do
      assert Submarine.epsilon_rate(inputs) == 9
    end

    test "get epsilon rate from file", %{file_inputs: file_inputs} do
      assert Submarine.epsilon_rate(file_inputs) == 3154
    end
  end

  describe "#power_consumption" do
    setup do
      {:ok, inputs: inputs(), file_inputs: file_inputs()}
    end

    test "get epsilon rate from multiple inputs by lines", %{inputs: inputs} do
      assert Submarine.power_consumption(inputs) == 198
    end

    test "get epsilon rate from file", %{file_inputs: file_inputs} do
      assert Submarine.power_consumption(file_inputs) == 2_967_914
    end
  end

  def inputs do
    """
    00100
    11110
    10110
    10111
    10101
    01111
    00111
    11100
    10000
    11001
    00010
    01010
    """
  end

  def file_inputs do
    file_path = System.get_env("INPUT_FILE_PATH", "test/data/input")
    File.read!(file_path)
  end
end
