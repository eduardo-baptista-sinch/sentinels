defmodule Sentinels.UtilsTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Sentinels.Utils

  defmodule Person do
    @moduledoc false

    defstruct [:name, :contacts, :address]
  end

  defmodule Address do
    @moduledoc false

    defstruct [:street, :city]
  end

  describe "struct_to_map/1" do
    test "returns map when provide struct with nested struct" do
      # Arrange
      params = %Person{name: "name", address: %Address{street: "street", city: "city"}}

      result = Utils.struct_to_map(params)

      expected_result = %{address: %{city: "city", street: "street"}, contacts: nil, name: "name"}
      assert result == expected_result
    end

    test "returns map when provide struct with nested list" do
      params = %Person{
        name: "name",
        contacts: [
          %Person{
            name: "name",
            address: %Address{
              street: "street",
              city: "city"
            }
          }
        ]
      }

      result = Utils.struct_to_map(params)

      expected_result = %{
        address: nil,
        contacts: [
          %{
            address: %{city: "city", street: "street"},
            contacts: nil,
            name: "name"
          }
        ],
        name: "name"
      }

      assert result == expected_result
    end

    test "returns a map when provides a map" do
      params = %{name: "name"}

      result = Utils.struct_to_map(params)

      expected_result = %{name: "name"}
      assert result == expected_result
    end
  end
end
