defmodule GetYourNutrients.FoodGroupTest do
  use GetYourNutrients.ModelCase

  alias GetYourNutrients.FoodGroup

  @valid_attrs %{description: "some content", foodgroup_id: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = FoodGroup.changeset(%FoodGroup{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = FoodGroup.changeset(%FoodGroup{}, @invalid_attrs)
    refute changeset.valid?
  end
end
