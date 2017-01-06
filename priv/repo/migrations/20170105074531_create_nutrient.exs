defmodule GetYourNutrients.Repo.Migrations.CreateNutrient do
  use Ecto.Migration

  def change do
    create table(:nutrients) do
      add :name, :string, null: false
      add :units_of_measure, :string, null: false

      timestamps()
    end

  end
end
