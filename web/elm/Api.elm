module Api exposing (..)

import Http exposing (send, get, Error)
import Models exposing (Nutrient, Food)
import Json.Decode exposing (int, string, float, nullable, Decoder, list)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)


findFoods : String -> (Result Error (List Food) -> a) -> Cmd a
findFoods food msg =
    let
        url =
            "api/food/search/" ++ food

        request =
            Http.get url (list decodeFood)
    in
        Http.send msg request


decodeNutrient : Decoder Nutrient
decodeNutrient =
    decode Nutrient
        |> required "nutrientId" string
        |> required "name" string
        |> required "percentage" int


decodeFood : Decoder Food
decodeFood =
    decode Food
        |> required "foodId" string
        |> required "name" string
        |> required "nutrients" (list decodeNutrient)
