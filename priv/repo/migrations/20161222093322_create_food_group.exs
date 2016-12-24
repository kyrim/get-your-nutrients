defmodule GetYourNutrients.Repo.Migrations.CreateFoodGroup do
  use Ecto.Migration

  def change do
    create table(:food_groups) do
      add :foodgroup_id, :string, size: 4, :primary_key: true
      add :description, :string

      timestamps()
    end

  end
end
