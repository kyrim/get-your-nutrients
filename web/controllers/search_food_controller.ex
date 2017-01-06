defmodule GetYourNutrients.SearchFoodController do
  use GetYourNutrients.Web, :controller

  alias GetYourNutrients.Food

  def show(conn, %{"searchKey" => searchKey}) do

    search_food = 
          Food
              |> Food.search(searchKey) 
              |> select([f], %{id: f.id, name: f.name})
              |> limit(10)
              |> Repo.all

    render(conn, "show.json", search_food: search_food)
  end
end
