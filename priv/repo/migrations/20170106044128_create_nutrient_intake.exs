defmodule GetYourNutrients.Repo.Migrations.CreateNutrientIntake do
  use Ecto.Migration

  def change do
    create table(:nutrient_intakes) do
      add :description, :string
      add :daily_intake, :decimal
      add :low_intake_amount, :decimal
      add :low_intake_description, :string
      add :high_intake_amount, :decimal
      add :high_intake_description, :string
      add :nutrient_id, references(:nutrients, on_delete: :nothing)

      timestamps()
    end
    create index(:nutrient_intakes, [:nutrient_id])

  end
end
