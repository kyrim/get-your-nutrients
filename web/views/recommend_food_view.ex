defmodule GetYourNutrients.RecommendFoodView do
  use GetYourNutrients.Web, :view

  def render("create.json", %{recommend_food: recommend_food}) do
    render_many(recommend_food, GetYourNutrients.RecommendFoodView, "recommend_food.json")
  end

  def render("recommend_food.json", %{recommend_food: recommend_food}) do
    %{
      foodId: recommend_food.foodId,
      name: recommend_food.name,
      nutrients: [] 
    }
  end
end
