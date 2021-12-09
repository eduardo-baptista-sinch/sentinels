defmodule SentinelsTest do
  @moduledoc false

  use ExUnit.Case

  alias Sentinels.Error
  alias Sentinels.Sentinel

  describe "validate/2" do
    test "returns map when validate with types definition" do
      definition = %{name: :string, age: :integer}
      params = %{name: "name", age: 25}

      result = Sentinels.validate(definition, params)

      expected_result = {:ok, %{age: 25, name: "name"}}
      assert result == expected_result
    end

    test "returns error when validate with types definition and invalid params" do
      definition = %{name: :string, age: :integer}
      params = %{name: "", age: "age"}

      result = Sentinels.validate(definition, params)

      expected_result = {
        :error,
        %Error{content: %{age: ["is invalid"], name: ["can't be blank"]}}
      }

      assert result == expected_result
    end

    defmodule SentinelImpl do
      @moduledoc false

      use Sentinel

      embedded_schema do
        field(:name, :string)
        field(:age, :integer)
      end
    end

    test "returns map when validate with sentinel validator" do
      params = %{name: "name", age: 25}

      result = Sentinels.validate(SentinelImpl, params)

      expected_result = {:ok, %{age: 25, name: "name"}}
      assert result == expected_result
    end

    test "returns error when validate with sentinel validator and invalid params" do
      definition = %{name: :string, age: :integer}
      params = %{name: "", age: "age"}

      result = Sentinels.validate(definition, params)

      expected_result = {
        :error,
        %Error{content: %{age: ["is invalid"], name: ["can't be blank"]}}
      }

      assert result == expected_result
    end
  end
end
