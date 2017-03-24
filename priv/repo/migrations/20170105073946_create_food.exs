defmodule GetYourNutrients.Repo.Migrations.CreateFood do
  use Ecto.Migration

  def change do
    create table(:foods) do
      add :name, :string, null: false
      add :protein_factor, :decimal, null: true
      add :fat_factor, :decimal, null: true
      add :carbohydrate_factor, :decimal, null: true

      timestamps()
    end
    execute "CREATE extension if not exists pg_trgm;"
    execute "CREATE INDEX foods_name_gin_index ON foods USING gin (name gin_trgm_ops);"

  end

  def down do
    execute "DROP INDEX foods_long_description_gin_index;"
  end
end
