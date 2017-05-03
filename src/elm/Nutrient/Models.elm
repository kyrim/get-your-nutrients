module Nutrient.Models exposing (..)


type NutrientType
    = Vitamin
    | Mineral


type alias NutrientId =
    String


type alias Nutrient =
    { id : NutrientId
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


type alias NutrientFlag =
    { id : String
    , name : String
    , description : String
    , dailyIntake : Float
    , lowIntakeAmount : Maybe Float
    , lowIntakeDescription : Maybe String
    , highIntakeAmount : Maybe Float
    , highIntakeDescription : Maybe String
    , unitOfMeasure : String
    , nutrientType : String
    }


nutrientFlagToNutrient : NutrientFlag -> Nutrient
nutrientFlagToNutrient nutrientFlag =
    let
        nutrientType =
            case nutrientFlag.nutrientType of
                "Vitamin" ->
                    Vitamin

                "Mineral" ->
                    Mineral

                _ ->
                    Vitamin
    in
        { id = nutrientFlag.id
        , name = nutrientFlag.name
        , description = nutrientFlag.description
        , amount = 0
        , hoveredAmount = 0
        , dailyIntake = nutrientFlag.dailyIntake
        , lowIntakeAmount = nutrientFlag.lowIntakeAmount
        , lowIntakeDescription = nutrientFlag.lowIntakeDescription
        , highIntakeAmount = nutrientFlag.highIntakeAmount
        , highIntakeDescription = nutrientFlag.highIntakeDescription
        , unitOfMeasure = nutrientFlag.unitOfMeasure
        , nutrientType = nutrientType
        }
