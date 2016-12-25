defmodule GetYourNutrients.Repo.Migrations.CreateLangualDescription do
  use Ecto.Migration

  def change do
    create table(:langual_descriptions, primary_key: false) do
      add :langual_description_id, :string, size: 5, primary_key: true
      add :description, :string, size: 140

      timestamps()
    end

  end
end
