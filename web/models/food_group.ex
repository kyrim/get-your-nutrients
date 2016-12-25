defmodule GetYourNutrients.FoodGroup do
  use GetYourNutrients.Web, :model

  @primary_key false
  schema "food_groups" do
    # 4-digit code identifying a food group. Only the first 2 digits are
    # currently assigned. In the future, the last 2 digits may be used.
    # Codes may not be consecutive.
    field :food_group_id, :string, primary_key: true

    # Name of food group.
    field :description, :string

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
