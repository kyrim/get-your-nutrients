defmodule GetYourNutrients.LangualFactorsTest do
  use GetYourNutrients.ModelCase

  alias GetYourNutrients.LangualFactors

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = LangualFactors.changeset(%LangualFactors{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = LangualFactors.changeset(%LangualFactors{}, @invalid_attrs)
    refute changeset.valid?
  end
end
