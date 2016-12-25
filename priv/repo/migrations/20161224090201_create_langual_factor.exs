defmodule GetYourNutrients.Repo.Migrations.CreateLangualFactor do
  use Ecto.Migration

  def change do
    create table(:langual_factors, primary_key: false) do
      add :food_id, size: 5, primary_key: true, references(:foods, on_delete: :nothing)
      add :langual_description_id, size: 5, primary_key: true, references(:langual_descriptions, on_delete: :nothing)

      timestamps()
    end
    create index(:langual_factors, [:food_id])
    create index(:langual_factors, [:langual_description_id])

  end
end
