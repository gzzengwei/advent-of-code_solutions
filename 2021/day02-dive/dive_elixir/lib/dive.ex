defmodule Dive do
  @moduledoc """
  Documentation for `Dive`.
  """

  require Logger

  alias Dive.Command
  alias Dive.Position

  def position_from_file(file_path) do
    file_path
    |> File.stream!()
    |> commands()
    |> position()
  end

  def position(commands) when is_list(commands) do
    commands
    |> Enum.reduce(%Position{}, &apply_command(&1, &2))
  end

  def commands_input(%Stream{} = inputs), do: commands(inputs)

  def commands_input(inputs) when is_binary(inputs) do
    with {:ok, stream} <- StringIO.open(inputs) do
      stream
      |> IO.binstream(:line)
      |> commands()
    end
  end

  defp commands(inputs) do
    inputs
    |> Stream.map(&String.trim/1)
    |> Stream.map(&command/1)
    |> Enum.to_list()
  end

  def apply_command(
        %Command{movement: "forward", steps: steps},
        %Position{horizontal: horizontal} = position
      ) do
    %Position{position | horizontal: horizontal + steps}
  end

  @max_depth 0
  def apply_command(
        %Command{movement: "up", steps: steps},
        %Position{depth: depth} = position
      )
      when depth - steps < @max_depth do
    Logger.error("Invalid commmand: up steps results in above sea level")
    position
  end

  def apply_command(
        %Command{movement: "up", steps: steps},
        %Position{depth: depth} = position
      ) do
    %Position{position | depth: depth - steps}
  end

  def apply_command(
        %Command{movement: "down", steps: steps},
        %Position{depth: depth} = position
      ) do
    %Position{position | depth: depth + steps}
  end

  defp command("forward " <> steps) do
    %Command{movement: "forward", steps: String.to_integer(steps)}
  end

  defp command("down " <> steps) do
    %Command{movement: "down", steps: String.to_integer(steps)}
  end

  defp command("up " <> steps) do
    %Command{movement: "up", steps: String.to_integer(steps)}
  end
end
