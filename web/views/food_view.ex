defmodule GetYourNutrients.FoodView do
  use GetYourNutrients.Web, :view

  def render("index.json", %{foods: foods}) do
    %{
      foods: Enum.map(foods, &food_json/1)
    }
  end

  def food_json(food) do
    %{
      foodId: food.food_id,
      longDescription: food.long_description,
      shortDescription: food.short_description
    }
  end
end