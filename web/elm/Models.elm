module Models exposing (..)


type alias Nutrient =
    { id : Int
    , name : String
    , percentage : Int
    }


type alias FoodNutrient =
    { nutrientId : Int
    , amount : Float
    }


type alias Food =
    { id : Int
    , name : String
    , nutrients : List FoodNutrient
    }
