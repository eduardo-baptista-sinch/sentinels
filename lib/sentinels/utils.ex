defmodule Sentinels.Utils do
  @moduledoc """
  General utilities functions
  """

  @doc """
  Convert structs and nested structs to maps

  ## Examples

      iex> Sentinels.Utils.struct_to_map(struct)
      map
  """
  @spec struct_to_map(struct() | map()) :: map()
  def struct_to_map(struct) when is_struct(struct) do
    struct
    |> Map.from_struct()
    |> convert_nested()
  end

  def struct_to_map(struct), do: struct

  defp convert_nested(map) when is_map(map) do
    Enum.into(map, %{}, fn
      {key, value} when is_struct(value) -> {key, struct_to_map(value)}
      {key, value} when is_list(value) -> {key, convert_nested(value)}
      field -> field
    end)
  end

  defp convert_nested(list) when is_list(list) do
    Enum.map(list, fn value -> struct_to_map(value) end)
  end
end
