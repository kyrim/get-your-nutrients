defmodule GetYourNutrients.Repo.Migrations.CreateFoodGroup do
  use Ecto.Migration

  def change do
    create table(:food_groups, primary_key: false) do
      add :food_group_id, :string, size: 4, primary_key: true
      add :description, :string, size: 60

      timestamps()
    end

  end
end
