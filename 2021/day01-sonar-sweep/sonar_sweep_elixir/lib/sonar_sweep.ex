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

  def measure_increases(list) when is_list(list), do: measure_increases_count(list)

  def measure_increases(%Stream{} = list), do: measure_increases_count(list)

  defp measure_increases_count(list) do
    list
    |> Enum.reduce({0, nil}, &aggregate_list/2)
    |> elem(0)
  end

  defp aggregate_list(data, {count, last_data}) do
    with new_count <- calculate_count(count, data > last_data) do
      {new_count, data}
    end
  end

  defp calculate_count(count, true), do: count + 1
  defp calculate_count(count, _increasesd), do: count
end
