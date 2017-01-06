defmodule GetYourNutrients.FoodTest do
  use GetYourNutrients.ModelCase

  alias GetYourNutrients.Food

  @valid_attrs %{carbohydrate_factor: "120.5", description: "some content", fat_factor: "120.5", protein_factor: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Food.changeset(%Food{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Food.changeset(%Food{}, @invalid_attrs)
    refute changeset.valid?
  end
end
