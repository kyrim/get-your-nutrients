module Models exposing (Nutrient, Food)


type alias Nutrient =
    { id : Int
    , name : String
    , percentage : Int
    }


type alias Food =
    { id : Int
    , name : String
    , nutrients : List Nutrient
    }
