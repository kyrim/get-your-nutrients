defmodule GetYourNutrients.SearchFoodTest do
  use GetYourNutrients.ModelCase

  alias GetYourNutrients.SearchFood

  @valid_attrs %{foodId: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SearchFood.changeset(%SearchFood{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SearchFood.changeset(%SearchFood{}, @invalid_attrs)
    refute changeset.valid?
  end
end
