defmodule Sentinels.Error do
  @moduledoc """
  Error definition returned by sentinels validations
  """

  @fields [:content]

  @enforce_keys @fields

  defstruct @fields

  alias Ecto.Changeset

  @typedoc """
  Error type definition
  """
  @type t :: %__MODULE__{content: map()}

  @doc """
  Build a new error struct from changeset validation

  ## Examples

        iex> Sentinels.Error.new(changeset)
        %Sentinels.Error{content: traversed_errors}
  """
  @spec new(Changeset.t()) :: t()
  def new(%Changeset{} = changeset) do
    %__MODULE__{content: traverse_errors(changeset)}
  end

  defp traverse_errors(changeset) do
    Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
        opts
        |> Keyword.get(String.to_existing_atom(key), key)
        |> to_string()
      end)
    end)
  end
end
