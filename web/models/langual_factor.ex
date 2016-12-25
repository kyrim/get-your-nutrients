defmodule GetYourNutrients.LangualFactor do
  use GetYourNutrients.Web, :model

  schema "langual_factors" do
    belongs_to :food, GetYourNutrients.Food
    belongs_to :langual_description, GetYourNutrients.LangualDescription

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
