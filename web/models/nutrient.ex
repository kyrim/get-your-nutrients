defmodule GetYourNutrients.Nutrient do
  use GetYourNutrients.Web, :model

  @primary_key false
  schema "nutrients" do
    # Amount in 100 grams, edible portion
    field :value, :string

    # Number of data points is the number of analyses used to calculate the
    # nutrient value. If the number of data points is 0,
    # the value was calculated or imputed.
    field :number_of_data_points, :string

    # Standard error of the mean. Null if cannot be calculated. The standard
    # error is also not given if the number of data points is less than three.   
    field :standard_error, :string

    # Standard error of the mean. Null if cannot be calculated.
    # The standard error is also not given if the number of data points
    # is less than three.
    field :source_code, :string

    # Data Derivation Code giving specific information on how the value is determined.
    # This field is populated only for items added or updated starting with SR14.
    # This field may not be populated if older records were used in the
    # calculation of the mean value.
    field :derivation_code, :string

    # NDB number of the item used to calculate a missing value.
    # Populated only for items added or updated starting with SR14.
    field :reference_food_id, :string

    # Indicates a vitamin or mineral added for fortification or enrichment.
    # This field is populated for ready-to- eat breakfast cereals and
    # many brand-name hot cereals in food group 08.    
    field :added_nutrient_mark, :string
    field :number_of_studies, :string
    field :minimum, :string
    field :maximum, :string
    field :degrees_of_freedom, :string

    # Lower 95% error bound.
    field :lower_error_bound, :string

    # Upper 95% error bound.
    field :upper_error_bound, :string

    # Statistical comments. See definitions below.
    field :statistical_comments, :string

    # Indicates when a value was either added to the database or last modified.
    field :last_modified, :string

    # Confidence Code indicating data quality, based on evaluation of sample
    # plan, sample handling, analytical method, analytical quality control,
    # and number of samples analyzed. Not included in this release, but is
    # planned for future releases.
    field :confidence_code, :string
    belongs_to :foods, GetYourNutrients.Food
    belongs_to :nutrient_descriptions, GetYourNutrients.NutrientDescription

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
