defmodule Sentinels.ErrorTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Ecto.Changeset
  alias Sentinels.Error

  describe "new/1" do
    test "returns formatted errors when provide a changeset" do
      params =
        changeset(%{"title" => "title", "body" => "body"})
        |> Changeset.validate_length(:title, min: 10)
        |> Changeset.validate_length(:body, min: 5)
        |> Changeset.validate_format(:body, ~r/888/)

      result = Error.new(params)

      expected_result = %Error{
        content: %{
          body: ["has invalid format", "should be at least 5 character(s)"],
          title: ["should be at least 10 character(s)"]
        }
      }

      assert result == expected_result
    end
  end

  defp changeset(params) do
    Changeset.cast({%{}, %{title: :string, body: :string}}, params, [:title, :body])
  end
end
