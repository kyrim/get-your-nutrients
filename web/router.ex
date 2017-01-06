defmodule GetYourNutrients.Router do
  use GetYourNutrients.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GetYourNutrients do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", GetYourNutrients do
    pipe_through :api

    scope "/food" do
        resources "/" , FoodController, only: [:show]
        resources "/search", SearchFoodController, only: [:show], param: "searchKey"
        resources "/recommend", RecommendFoodController, only: [:create]
    end
  end
end
