defmodule GetYourNutrients.Repo.Migrations.CreateFoodGroup do
  use Ecto.Migration

  def change do
    create table(:food_groups) do
      add :description, :string

      timestamps()
    end

  end
end
