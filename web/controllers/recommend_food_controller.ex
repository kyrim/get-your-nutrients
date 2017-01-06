defmodule GetYourNutrients.RecommendFoodController do
  use GetYourNutrients.Web, :controller

  alias GetYourNutrients.Food

    def create(conn, params) do
        
    recommend_food = 
          Food
              |> Food.recommend(params) 
              |> select([f], %{id: f.id, name: f.name})
              |> limit(10)
              |> Repo.all

    render(conn, "create.json", recommend_food: recommend_food)

    end

end