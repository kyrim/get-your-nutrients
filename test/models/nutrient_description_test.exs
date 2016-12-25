defmodule GetYourNutrients.NutrientDescriptionTest do
  use GetYourNutrients.ModelCase

  alias GetYourNutrients.NutrientDescription

  @valid_attrs %{description: "some content", nutrient_description_id: "some content", precision: "some content", sort_order: "some content", tag_name: "some content", units: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = NutrientDescription.changeset(%NutrientDescription{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = NutrientDescription.changeset(%NutrientDescription{}, @invalid_attrs)
    refute changeset.valid?
  end
end
