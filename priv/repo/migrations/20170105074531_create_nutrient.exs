defmodule GetYourNutrients.Repo.Migrations.CreateNutrient do
  use Ecto.Migration

  def change do
    create table(:nutrients) do
      add :name, :string
      add :units_of_measure, :string

      timestamps()
    end

  end
end
