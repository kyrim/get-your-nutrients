module Models exposing (Nutrient, Food)


type alias Nutrient =
    { nutrientId : String
    , name : String
    , percentage : Int
    }


type alias Food =
    { foodId : String
    , name : String
    , nutrients : List Nutrient
    }
