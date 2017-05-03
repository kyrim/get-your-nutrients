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
    , quantity : Int
    , nutrients : List FoodNutrient
    }


type alias FoodFlag =
    { id : String
    , name : String
    , nutrients : List FoodNutrient
    }


foodFlagToFood : FoodFlag -> Food
foodFlagToFood foodFlag =
    { id = foodFlag.id
    , name = foodFlag.name
    , amount = 0
    , quantity = 0
    , nutrients = foodFlag.nutrients
    }
