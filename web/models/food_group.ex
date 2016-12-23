defmodule GetYourNutrients.FoodGroup do
  use GetYourNutrients.Web, :model

  schema "food_groups" do
    field :foodgroup_id, :string
    field :description, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:foodgroup_id, :description])
    |> validate_required([:foodgroup_id, :description])
  end
end
