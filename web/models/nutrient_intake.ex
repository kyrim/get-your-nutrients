defmodule GetYourNutrients.NutrientIntake do
  use GetYourNutrients.Web, :model

  schema "nutrient_intakes" do
    field :description, :string, null: false
    field :daily_intake, :decimal, null: false
    field :low_intake_amount, :decimal
    field :low_intake_description, :string
    field :high_intake_amount, :decimal
    field :high_intake_description, :string
    belongs_to :nutrient, GetYourNutrients.Nutrient

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description, :daily_intake, :low_intake_amount, :low_intake_description, :high_intake_amount, :high_intake_description])
    |> validate_required([:description, :daily_intake, :low_intake_amount, :low_intake_description, :high_intake_amount, :high_intake_description])
  end
end
