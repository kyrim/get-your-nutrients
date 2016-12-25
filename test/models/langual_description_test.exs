defmodule GetYourNutrients.LangualDescriptionTest do
  use GetYourNutrients.ModelCase

  alias GetYourNutrients.LangualDescription

  @valid_attrs %{description: "some content", factor_code: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = LangualDescription.changeset(%LangualDescription{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = LangualDescription.changeset(%LangualDescription{}, @invalid_attrs)
    refute changeset.valid?
  end
end
