defmodule GetYourNutrients.LangualDescription do
  use GetYourNutrients.Web, :model

  @primary_key false
  schema "langual_descriptions" do
    # The LanguaL factor from the Thesaurus. Only those codes used to factor
    # the foods contained in the LanguaL Factor file are included in this file.
    field :langual_description_id, :string, primary_key: true

    # The description of the LanguaL Factor Code from the thesaurus.
    field :description, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:factor_code, :description])
    |> validate_required([:factor_code, :description])
  end
end
