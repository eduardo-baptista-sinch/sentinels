defmodule Sentinels.Sentinel do
  @moduledoc """
  Defines a struct to cast and validate params:

        defmodule Validator do
          use Sentinels.Sentinel

            embedded_schema do
              field :name, :string
              field :age, :integer
            end
        end

  It is possible to pass some options to customize the cast behaviour:

          defmodule Validator do
            use Sentinels.Sentinel, optional_fields: [:name]

              embedded_schema do
                field :name, :string
                field :age, :integer
              end

  ## Options

    * `:optional_fields` - List with fields to ignore on validate required, defaults to `[]`
    * `:cast_fields` - List to customize allowed fields to cast, by default all fields are allowed


  To add additional validation to the struct it is possible to define a `validate` method, this method will receives a
  changeset and must return a changeset:

        defmodule Validator do
          use Sentinels.Sentinel

            embedded_schema do
              field :name, :string
              field :age, :integer
            end

            def validate(changeset)
              changeset
              |> validate_length(:name, min: 3, max: 10)
              |> validate_number(:age, greater_than: 18)
            end
        end
  """

  alias Ecto.Changeset

  @callback validate(Changeset.t()) :: Changeset.t()

  defmacro __using__(opts) do
    quote do
      use Ecto.Schema

      import Ecto.Changeset

      @before_compile unquote(__MODULE__)

      @behaviour unquote(__MODULE__)

      @primary_key false

      @cast_fields Keyword.get(unquote(opts), :cast_fields)
      @optional_fields Keyword.get(unquote(opts), :optional_fields, [])

      def validate(changeset), do: changeset
      defoverridable validate: 1
    end
  end

  defmacro __before_compile__(_) do
    quote do
      @fields Keyword.keys(@struct_fields) -- Keyword.keys(@ecto_embeds)

      def changeset(struct \\ %__MODULE__{}, params) do
        struct
        |> Ecto.Changeset.cast(params, @cast_fields || @fields)
        |> Ecto.Changeset.validate_required(@fields -- @optional_fields)
        |> validate()
      end
    end
  end
end
