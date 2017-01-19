module Food.Models exposing (..)


type alias FoodNutrient =
    { nutrientId : Int
    , amount : Float
    }


type alias Food =
    { id : Int
    , name : String
    , amount : Int
    , quantity : Int
    , nutrients : List FoodNutrient
    }
