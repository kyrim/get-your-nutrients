defmodule GetYourNutrients.Food do
  use GetYourNutrients.Web, :model

  schema "foods" do
    field :name, :string
    field :protein_factor, :decimal, null: true
    field :fat_factor, :decimal, null: true
    field :carbohydrate_factor, :decimal, null: true
    belongs_to :food_group, GetYourNutrients.FoodGroup
    has_many :food_nutrients, GetYourNutrients.FoodNutrient
    
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :protein_factor, :fat_factor, :carbohydrate_factor])
    |> validate_required([:name, :protein_factor, :fat_factor, :carbohydrate_factor])
  end

    def search(query, search_term) do
    from(u in query,
    where: fragment("similarity(?, ?) > ?", u.name, ^search_term, 0.2),
    order_by: fragment("similarity(?, ?) DESC", u.name, ^search_term))
  end

   def recommend(query, recommended_foods) do
    from(u in query,
    where: fragment("similarity(?, ?) > ?", u.name, ^recommended_foods, 0.2),
    order_by: fragment("similarity(?, ?) DESC", u.name, ^recommended_foods))
  end
end
