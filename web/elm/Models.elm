module Models exposing (..)


type NutrientType
    = Vitamin
    | Mineral


type alias Nutrient =
    { id : Int
    , name : String
    , description : String
    , amount : Float
    , dailyIntake : Float
    , lowIntakeAmount : Maybe Float
    , lowIntakeDescription : Maybe String
    , highIntakeAmount : Maybe Float
    , highIntakeDescription : Maybe String
    , unitOfMeasure : String
    , nutrientType : NutrientType
    }


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
