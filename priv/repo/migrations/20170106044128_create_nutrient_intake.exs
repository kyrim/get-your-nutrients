defmodule GetYourNutrients.Repo.Migrations.CreateNutrientIntake do
  use Ecto.Migration

  def change do
    create table(:nutrient_intakes) do
      add :description, :text, null: false
      add :daily_intake, :decimal, null: false
      add :low_intake_amount, :decimal
      add :low_intake_description, :text
      add :high_intake_amount, :decimal
      add :high_intake_description, :text
      add :nutrient_id, references(:nutrients, on_delete: :nothing), null: false

      timestamps()
    end
    create index(:nutrient_intakes, [:nutrient_id])

  end
end
