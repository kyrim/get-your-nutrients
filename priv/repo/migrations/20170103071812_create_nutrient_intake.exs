defmodule GetYourNutrients.Repo.Migrations.CreateNutrientIntake do
  use Ecto.Migration

  def change do
    create table(:nutrient_intake) do
      add :daily_intake, :decimal
      add :low_intake_effects, :string
      add :high_intake_effects, :string
      add :low_intake_amount, :decimal
      add :high_intake_amount, :decimal
      add :nutrient_description_id, references(:nutrient_description, on_delete: :nothing)

      timestamps()
    end
    create unique_index(:nutrient_intake, [:nutrient_description_id])

  end
end
