defmodule GetYourNutrients.SourceCodeTest do
  use GetYourNutrients.ModelCase

  alias GetYourNutrients.SourceCode

  @valid_attrs %{description: "some content", source_code_id: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SourceCode.changeset(%SourceCode{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SourceCode.changeset(%SourceCode{}, @invalid_attrs)
    refute changeset.valid?
  end
end
