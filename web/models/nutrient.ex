defmodule GetYourNutrients.Nutrient do
  use GetYourNutrients.Web, :model

  schema "nutrients" do
    field :name, :string, null: false
    field :unit_of_measure, :string
    has_one :nutrient_intake, NutrientIntake
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :unit_of_measure])
    |> validate_required([:name, :unit_of_measure])
  end
end
