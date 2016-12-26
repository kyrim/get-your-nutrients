defmodule GetYourNutrients.FoodGroup do
  use GetYourNutrients.Web, :model

  @primary_key {:food_group_id, :string, []}
  @derive {Phoenix.Param, key: :food_group_id}
  schema "food_groups" do
    
    # Name of food group.
    field :description, :string

# 4-digit code indicating food group to which a food item belongs.
    has_many :foods, GetYourNutrients.Food

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:food_group_id, :description])
    |> validate_required([:food_group_id, :description])
  end
end
