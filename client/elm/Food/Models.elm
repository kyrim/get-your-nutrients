module Food.Models exposing (..)

import List


type alias FoodNutrient =
    { nutrientId : String
    , amount : Float
    }


type alias FoodId =
    String


type alias Food =
    { id : FoodId
    , name : String
    , amount : Int
    , nutrients : List FoodNutrient
    }


type alias SearchFood =
    { id : String
    , name : String
    }
