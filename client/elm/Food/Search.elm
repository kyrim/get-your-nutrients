port module Food.Search exposing (..)

import Food.Models exposing (FoodId)


port foodSearch : String -> Cmd msg


port foodSearchResults : (List FoodId -> msg) -> Sub msg
