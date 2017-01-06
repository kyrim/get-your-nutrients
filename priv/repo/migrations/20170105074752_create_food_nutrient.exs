defmodule GetYourNutrients.Repo.Migrations.CreateFoodNutrient do
  use Ecto.Migration

  def change do
    create table(:food_nutrients) do
      add :amount, :decimal
      add :food_id, references(:foods, on_delete: :nothing)
      add :nutrient_id, references(:nutrients, on_delete: :nothing)

      timestamps()
    end
    create index(:food_nutrients, [:food_id])
    create index(:food_nutrients, [:nutrient_id])

  end
end
