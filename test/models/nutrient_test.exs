defmodule GetYourNutrients.NutrientTest do
  use GetYourNutrients.ModelCase

  alias GetYourNutrients.Nutrient

  @valid_attrs %{added_nutrient_mark: "some content", confidence_code: "some content", degrees_of_freedom: "some content", derivation_code: "some content", last_modified: "some content", lower_error_bound: "some content", maximum: "some content", minimum: "some content", number_of_data_points: "some content", number_of_studies: "some content", reference_food_id: "some content", source_code: "some content", standard_error: "some content", statistical_comments: "some content", upper_error_bound: "some content", value: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Nutrient.changeset(%Nutrient{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Nutrient.changeset(%Nutrient{}, @invalid_attrs)
    refute changeset.valid?
  end
end
