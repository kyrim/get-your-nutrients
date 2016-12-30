defmodule GetYourNutrients.SearchFoodController do
  use GetYourNutrients.Web, :controller

  alias GetYourNutrients.Food

  def show(conn, %{"searchKey" => searchKey}) do

    search_food = 
          Food
              |> Food.search(searchKey) 
              |> select([f], %{foodId: f.food_id, name: f.long_description})
              |> limit(20)
              |> Repo.all

    render(conn, "show.json", search_food: search_food)
  end
end
