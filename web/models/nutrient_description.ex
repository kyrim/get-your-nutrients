defmodule GetYourNutrients.NutrientDescription do
  use GetYourNutrients.Web, :model

  @primary_key {:nutrient_description_id, :string, []}
  @derive {Phoenix.Param, key: :nutrient_description_id}
  schema "nutrient_descriptions" do
    
    # Units of measure (mg, g, μg, and so on).
    field :units, :string

    # International Network of Food Data Systems (INFOODS) Tagnames. A unique
    # abbreviation for a nutrient/food component developed by INFOODS to aid
    # in the interchange of data.
    field :tag_name, :string

    # Name of nutrient/food component.
    field :description, :string

    # Number of decimal places to which a nutrient value is rounded.
    field :precision, :string

    # Used to sort nutrient records in the same order as various reports
    # produced from SR.
    field :sort_order, :integer

    has_many :nutrients, GetYourNutrients.Nutrient

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:nutrient_description_id, :units, :tag_name, :description, :precision, :sort_order])
    |> validate_required([:nutrient_description_id, :units, :tag_name, :description, :precision, :sort_order])
  end
end
