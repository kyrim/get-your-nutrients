defmodule GetYourNutrients.LangualFactorTest do
  use GetYourNutrients.ModelCase

  alias GetYourNutrients.LangualFactor

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = LangualFactor.changeset(%LangualFactor{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = LangualFactor.changeset(%LangualFactor{}, @invalid_attrs)
    refute changeset.valid?
  end
end
