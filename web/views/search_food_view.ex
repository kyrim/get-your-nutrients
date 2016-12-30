defmodule GetYourNutrients.SearchFoodView do
  use GetYourNutrients.Web, :view

  def render("show.json", %{search_food: search_food}) do
    render_many(search_food, GetYourNutrients.SearchFoodView, "search_food.json")
  end

  def render("search_food.json", %{search_food: search_food}) do
    %{
      foodId: search_food.foodId,
      name: search_food.name,
      nutrients: [] 
    }
  end
end
