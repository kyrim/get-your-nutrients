module Nutrient.Models exposing (..)


type NutrientType
    = Vitamin
    | Mineral


type alias Nutrient =
    { id : Int
    , name : String
    , description : String
    , amount : Float
    , hoveredAmount : Float
    , dailyIntake : Float
    , lowIntakeAmount : Maybe Float
    , lowIntakeDescription : Maybe String
    , highIntakeAmount : Maybe Float
    , highIntakeDescription : Maybe String
    , unitOfMeasure : String
    , nutrientType : NutrientType
    }
