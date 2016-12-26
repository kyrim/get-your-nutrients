defmodule GetYourNutrients.Repo.Migrations.CreateNutrient do
  use Ecto.Migration

  def change do
    create table(:nutrients) do
      # Amount in 100 grams, edible portion
      add :value, :string

      # Number of data points is the number of analyses used to calculate the
      # nutrient value. If the number of data points is 0,
      # the value was calculated or imputed.
      add :number_of_data_points, :string

      # Standard error of the mean. Null if cannot be calculated. The standard
      # error is also not given if the number of data points is less than three.
      add :standard_error, :string

      # Standard error of the mean. Null if cannot be calculated.
      # The standard error is also not given if the number of data points
      # is less than three.
      add :source_code, :string

      # Data Derivation Code giving specific information on how the value is determined.
      # This field is populated only for items added or updated starting with SR14.
      # This field may not be populated if older records were used in the
      # calculation of the mean value.
      add :derivation_code, :string

      # NDB number of the item used to calculate a missing value.
      # Populated only for items added or updated starting with SR14.
      add :reference_food_id, :string

      # Indicates a vitamin or mineral added for fortification or enrichment.
      # This field is populated for ready-to- eat breakfast cereals and
      # many brand-name hot cereals in food group 08.
      add :added_nutrient_mark, :string
      add :number_of_studies, :string
      add :minimum, :string
      add :maximum, :string
      add :degrees_of_freedom, :string

      # Lower 95% error bound.
      add :lower_error_bound, :string

      # Upper 95% error bound.
      add :upper_error_bound, :string

      # Statistical comments. See definitions below.
      add :statistical_comments, :string

      # Indicates when a value was either added to the database or last modified.
      add :last_modified, :string

      # Confidence Code indicating data quality, based on evaluation of sample
      # plan, sample handling, analytical method, analytical quality control,
      # and number of samples analyzed. Not included in this release, but is
      # planned for future releases.
      add :confidence_code, :string
      
      add :food_id, references(:food, on_delete: :nothing)
      add :nutrient_description_id, references(:nutrient_description, on_delete: :nothing)

      timestamps()
    end
    create index(:nutrients, [:food_id])
    create index(:nutrients, [:nutrient_description_id])

  end
end
