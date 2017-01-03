defmodule GetYourNutrients.NutrientIntakeTest do
  use GetYourNutrients.ModelCase

  alias GetYourNutrients.NutrientIntake

  @valid_attrs %{daily_intake: "120.5", high_intake_amount: "120.5", high_intake_effects: "some content", low_intake_amount: "120.5", low_intake_effects: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = NutrientIntake.changeset(%NutrientIntake{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = NutrientIntake.changeset(%NutrientIntake{}, @invalid_attrs)
    refute changeset.valid?
  end
end
