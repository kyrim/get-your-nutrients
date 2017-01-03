defmodule GetYourNutrients.NutrientIntake do
  use GetYourNutrients.Web, :model

  schema "nutrient_intake" do
    field :daily_intake, :decimal
    field :low_intake_effects, :string
    field :high_intake_effects, :string
    field :low_intake_amount, :decimal
    field :high_intake_amount, :decimal
    belongs_to :nutrient_description, GetYourNutrients.NutrientDescription

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:daily_intake, :low_intake_effects, :high_intake_effects, :low_intake_amount, :high_intake_amount])
    |> validate_required([:daily_intake, :low_intake_effects, :high_intake_effects, :low_intake_amount, :high_intake_amount])
    |> unique_constraint(:nutrient_description_id)
  end
end
