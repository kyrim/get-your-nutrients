defmodule GetYourNutrients.Repo.Migrations.CreateNutrientDescription do
  use Ecto.Migration

  def change do
    create table(:nutrient_descriptions, primary_key: false)) do
      add :nutrient_description_id, :string, size: 3, primary_key: true
      add :units, :string, size: 7, null: false
      add :tag_name, :string, size: 20
      add :description, :string, size: 60, null: false
      add :precision, :string, size: 1, null: false
      add :sort_order, :integer, null: false

      timestamps()
    end

  end
end
