defmodule GetYourNutrients.FoodController do
  use GetYourNutrients.Web, :controller

  alias GetYourNutrients.Food

    def show(conn, %{"id" => id}) do

    food = Repo.get!(Food, id)
         |> Repo.preload(:food_nutrients)
         
    render(conn, "show.json", food: food)
  end
end