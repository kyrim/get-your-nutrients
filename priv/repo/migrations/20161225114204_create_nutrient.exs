defmodule GetYourNutrients.Repo.Migrations.CreateNutrient do
  use Ecto.Migration

  def change do
    create table(:nutrients, primary_key: false) do
      add :food_id, references(:foods, column: :food_id, type: :string)
      add :nutrient_description_id, references(:nutrient_descriptions, column: :nutrient_description_id, type: :string)
      add :value, :string
      add :number_of_data_points, :string
      add :standard_error, :string
      add :source_code, :string
      add :derivation_code, :string
      add :reference_food_id, :string
      add :added_nutrient_mark, :string
      add :number_of_studies, :string
      add :minimum, :string
      add :maximum, :string
      add :degrees_of_freedom, :string
      add :lower_error_bound, :string
      add :upper_error_bound, :string
      add :statistical_comments, :string
      add :last_modified, :string
      add :confidence_code, :string
    end
    create index(:nutrients, [:food_id])
    create index(:nutrients, [:nutrient_description_id])

  end
end
