defmodule GetYourNutrients.Nutrient do
  use GetYourNutrients.Web, :model

  schema "nutrients" do
    field :value, :string
    field :number_of_data_points, :string
    field :standard_error, :string
    field :source_code, :string
    field :derivation_code, :string
    field :reference_food_id, :string
    field :added_nutrient_mark, :string
    field :number_of_studies, :string
    field :minimum, :string
    field :maximum, :string
    field :degrees_of_freedom, :string
    field :lower_error_bound, :string
    field :upper_error_bound, :string
    field :statistical_comments, :string
    field :last_modified, :string
    field :confidence_code, :string
    belongs_to :food, GetYourNutrients.Food
    belongs_to :nutrient_description, GetYourNutrients.NutrientDescription

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:value, :number_of_data_points, :standard_error, :source_code, :derivation_code, :reference_food_id, :added_nutrient_mark, :number_of_studies, :minimum, :maximum, :degrees_of_freedom, :lower_error_bound, :upper_error_bound, :statistical_comments, :last_modified, :confidence_code])
    |> validate_required([:value, :number_of_data_points, :standard_error, :source_code, :derivation_code, :reference_food_id, :added_nutrient_mark, :number_of_studies, :minimum, :maximum, :degrees_of_freedom, :lower_error_bound, :upper_error_bound, :statistical_comments, :last_modified, :confidence_code])
  end
end
