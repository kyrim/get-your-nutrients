defmodule GetYourNutrients.Repo.Migrations.CreateFoodNutrient do
  use Ecto.Migration

  def change do
    create table(:food_nutrients) do
      add :amount, :decimal, null: false
      add :food_id, references(:foods, on_delete: :nothing), null: false
      add :nutrient_id, references(:nutrients, on_delete: :nothing), null: false

      timestamps()
    end
    create index(:food_nutrients, [:food_id])
    create index(:food_nutrients, [:nutrient_id])
    create index(:food_nutrients, [:amount])
  end
end
