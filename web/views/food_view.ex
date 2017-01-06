defmodule GetYourNutrients.FoodView do
  use GetYourNutrients.Web, :view

  def render("show.json", %{food: food}) do
    render_one(food, GetYourNutrients.FoodView, "food.json")
  end

  def render("food.json", %{food: food}) do
    %{
      id: food.id,
      name: food.name,
      foodNutrients: food.food_nutrients 
        |> Enum.map(&(
          %{
              nutrientId: &1.nutrient_id,
              amount: &1.amount
          })
        ) 
    }
  end
end