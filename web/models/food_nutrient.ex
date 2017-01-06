defmodule GetYourNutrients.FoodNutrient do
  use GetYourNutrients.Web, :model

  schema "food_nutrients" do
    field :amount, :decimal, null: false
    belongs_to :food, GetYourNutrients.Food
    belongs_to :nutrient, GetYourNutrients.Nutrient

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:amount])
    |> validate_required([:amount])
  end
end
