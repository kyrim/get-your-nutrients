defmodule GetYourNutrients.FoodTest do
  use GetYourNutrients.ModelCase

  alias GetYourNutrients.Food

  @valid_attrs %{carbohydrate_factor: "some content", common_name: "some content", fat_factor: "some content", food_id: "some content", long_description: "some content", manufacturer_name: "some content", nitrogen_factor: "some content", protein_factor: "some content", refuse_description: "some content", refuse_percentage: "some content", scientific_name: "some content", short_description: "some content", survey: "some content"}
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
