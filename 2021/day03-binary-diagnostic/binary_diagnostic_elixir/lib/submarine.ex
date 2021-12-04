defmodule Submarine do
  @moduledoc """
  Documentation for `Submarine`.
  """

  def power_consumption(inputs) do
    gamma_rate(inputs) * epsilon_rate(inputs)
  end

  def gamma_rate(inputs) do
    inputs
    |> sanitize_input()
    |> rotae_lists()
    |> lists_by_count()
    |> Enum.map(&min_max_list/1)
    |> binary_list(:gamma)
    |> convert_to_integer()
  end

  def epsilon_rate(inputs) do
    inputs
    |> sanitize_input()
    |> rotae_lists()
    |> lists_by_count()
    |> Enum.map(&min_max_list/1)
    |> binary_list(:epsilon)
    |> convert_to_integer()
  end

  def sanitize_input(inputs) do
    inputs
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
  end

  def rotae_lists(list) do
    list
    |> Enum.map(&Enum.with_index(&1))
    |> Enum.reduce(%{}, &reduce_rotate_list/2)
    |> Map.values()
  end

  def reduce_rotate_list(list, acc) do
    list
    |> Enum.reduce(acc, fn {data, index}, acc ->
      new_data = (acc[index] || []) ++ [data]
      Map.put(acc, index, new_data)
    end)
  end

  def element_occurrences(list) do
    list
    |> Enum.reduce(%{}, fn element, acc ->
      new_count = (acc[element] || 0) + 1
      Map.put(acc, element, new_count)
    end)
  end

  def lists_by_count(lists) do
    lists
    |> Enum.map(&element_occurrences/1)
  end

  def min_max_list(list) do
    list
    |> Enum.min_max_by(&elem(&1, 1))
  end

  def get_max_list(list) do
    list |> elem(1) |> elem(0)
  end

  def get_min_list(list) do
    list |> elem(0) |> elem(0)
  end

  def binary_list(list, :gamma) do
    list
    |> Enum.map(&get_max_list/1)
    |> Enum.join()
  end

  def binary_list(list, :epsilon) do
    list
    |> Enum.map(&get_min_list/1)
    |> Enum.join()
  end

  def convert_to_integer(binary) do
    binary
    |> Integer.parse(2)
    |> elem(0)
  end
end
