defmodule GetYourNutrients.Repo.Migrations.CreateLangualFactor do
  use Ecto.Migration

  def change do
    create table(:langual_factors, primary_key: false) do
      add :food_id, references(:foods, [column: :food_id, type: :string])
      add :langual_description_id, references(:langual_descriptions, [column: :langual_description_id, type: :string])

      timestamps()
    end
    create index(:langual_factors, [:food_id])
    create index(:langual_factors, [:langual_description_id])

  end
end
