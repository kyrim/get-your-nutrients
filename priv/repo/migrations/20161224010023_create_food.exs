defmodule GetYourNutrients.Repo.Migrations.CreateFood do
  use Ecto.Migration

  def change do
    create table(:foods) do
      add :food_id, :string, size: 5, primary_key: true
      add :long_description, :string, size: 200
      add :short_description, :string, size: 60
      add :common_name, :string, size: 100
      add :manufacturer_name, :string, size: 65
      add :survey, :string, size: 1
      add :refuse_description, :string, size: 135
      add :refuse_percentage, :integer
      add :scientific_name, :string, size: 65
      add :nitrogen_factor, :float
      add :protein_factor, :float
      add :fat_factor, :float
      add :carbohydrate_factor, :float
      add :food_group_id, :string, references(:food_groups, column: :food_group_id)

      timestamps()
    end
    create index(:foods, [:food_group_id])

  end
end
