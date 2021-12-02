defmodule SonarSweep do
  @moduledoc """
  Documentation for `SonarSweep`.
  """

  def measure_from_file(file_path) do
    File.stream!(file_path)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> measure_increases()
  end

  def measure_blocks_from_file(file_path) do
    File.stream!(file_path)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> measure_increases_blocks()
  end

  def measure_increases_blocks(list) do
    list
    |> window_blocks()
    |> measure_increases_count(&compare_block/2)
  end

  @block_size 3
  def window_blocks(list) do
    list
    |> Enum.with_index()
    |> Enum.map(&window_block(&1, list))
    |> Enum.filter(&remove_invalid_block/1)
  end

  def measure_increases(list) when is_list(list) do
    measure_increases_count(list, &compare_element/2)
  end

  def measure_increases(%Stream{} = list) do
    measure_increases_count(list, &compare_element/2)
  end

  def window_block({_item, index}, list) do
    Enum.slice(list, index..(index + @block_size - 1))
  end

  defp remove_invalid_block(block) when length(block) == @block_size, do: true
  defp remove_invalid_block(_block), do: false

  defp measure_increases_count(list, compare_func) do
    list
    |> Enum.reduce({0, nil}, &aggregate_list(&1, &2, compare_func))
    |> elem(0)
  end

  defp compare_block(_current_data, nil), do: false

  defp compare_block(current_data, last_data) do
    Enum.sum(current_data) > Enum.sum(last_data)
  end

  defp compare_element(current_data, last_data) do
    current_data > last_data
  end

  defp aggregate_list(data, {count, last_data}, compare_func) do
    with new_count <- calculate_count(count, compare_func.(data, last_data)) do
      {new_count, data}
    end
  end

  defp calculate_count(count, true), do: count + 1
  defp calculate_count(count, _increasesd), do: count
end
