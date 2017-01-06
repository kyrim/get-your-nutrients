defmodule GetYourNutrients.FoodNutrientTest do
  use GetYourNutrients.ModelCase

  alias GetYourNutrients.FoodNutrient

  @valid_attrs %{amount: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = FoodNutrient.changeset(%FoodNutrient{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = FoodNutrient.changeset(%FoodNutrient{}, @invalid_attrs)
    refute changeset.valid?
  end
end
