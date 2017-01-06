defmodule GetYourNutrients.RecommendFoodView do
  use GetYourNutrients.Web, :view

  def render("create.json", %{recommend_food: recommend_food}) do
    render_many(recommend_food, GetYourNutrients.RecommendFoodView, "recommend_food.json")
  end

  def render("recommend_food.json", %{recommend_food: recommend_food}) do
    %{
      id: recommend_food.id,
      name: recommend_food.name,
      foodNutrients: [] 
    }
  end
end
