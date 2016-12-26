defmodule GetYourNutrients.FoodController do
  use GetYourNutrients.Web, :controller

  alias GetYourNutrients.Food

  def index(conn, _params) do
    foods = Food |> Repo.all    
    render conn, "index.json", foods: foods
  end
end