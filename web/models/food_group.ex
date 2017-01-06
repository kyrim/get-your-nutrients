defmodule GetYourNutrients.FoodGroup do
  use GetYourNutrients.Web, :model

  schema "food_groups" do
    field :description, :string, null: false
    has_many :foods, GetYourNutrients.Food

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description])
    |> validate_required([:description])
  end
end
