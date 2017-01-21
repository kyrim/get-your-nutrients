module Food.Models exposing (..)


type alias FoodNutrient =
    { nutrientId : Int
    , amount : Float
    }


type alias FoodId =
    Int


type alias Food =
    { id : FoodId
    , name : String
    , amount : Int
    , quantity : Int
    , nutrients : List FoodNutrient
    }
