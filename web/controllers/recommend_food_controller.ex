defmodule GetYourNutrients.RecommendFoodController do
  use GetYourNutrients.Web, :controller

  alias GetYourNutrients.Food
  alias GetYourNutrients.FoodNutrient
  alias GetYourNutrients.NutrientIntake
  alias GetYourNutrients.Nutrient

    def create(conn, %{"_json" => ids}) do

      recommend_food = 
            Repo.all from f in Food,
            join: fn_ in FoodNutrient, where: fn_.food_id == f.id,
            join: n in Nutrient, where: fn_.nutrient_id == n.id,
            join: ni in NutrientIntake, where: ni.nutrient_id == n.id,
            where: not f.id in ^ids,
            
            select: %{
              id: f.id,
              name: f.name,
              foodNutrients: []
            }, limit: 10

      render(conn, "create.json", recommend_food: recommend_food)
    end

end