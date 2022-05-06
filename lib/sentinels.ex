defmodule Sentinels do
  @moduledoc """
  Help the validation and sanitization of request params.
  """

  alias Ecto.Changeset
  alias Sentinels.Error
  alias Sentinels.Utils

  @doc """
  Validate the request params.

  ## Examples:

  Using with types definitions:

        iex> definitions = %{name: :string, age: :integer}
        iex> params = %{"name" => "name", "age" => 25}
        iex> Sentinels.validate(definitions, params)
        {:ok, %{name: "name", age: 25}}

  Using with `Sentinel` struct:

        defmodule Validator do
          use Sentinels.Sentinel

            embedded_schema do
              field :name, :string
              field :age, :integer
            end
        end

        iex> Sentinels.validate(validator, params)
        iex> {:ok, %{name: "name", age: 25}}
  """
  @spec validate(atom() | map(), map()) :: {:error, Error.t()} | {:ok, map()}
  def validate(sentinel, data) when is_atom(sentinel) do
    data
    |> sentinel.changeset()
    |> handle_changeset()
  end

  def validate(definition, data) when is_map(definition) do
    keys = Map.keys(definition)

    {%{}, definition}
    |> Changeset.cast(data, keys)
    |> Changeset.validate_required(keys)
    |> handle_changeset()
  end

  def validate(sentinel, struct, data) when is_atom(sentinel) do
    struct
    |> sentinel.changeset(data)
    |> handle_changeset()
  end

  defp handle_changeset(changeset) do
    case Changeset.apply_action(changeset, :validate) do
      {:ok, result} -> {:ok, Utils.struct_to_map(result)}
      {:error, changeset} -> {:error, Error.new(changeset)}
    end
  end
end
