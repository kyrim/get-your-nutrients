defmodule GetYourNutrients.LangualDescription do
  use GetYourNutrients.Web, :model

  @primary_key {:langual_description_id, :string, []}
  @derive {Phoenix.Param, key: :langual_description_id}
  schema "langual_descriptions" do
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
