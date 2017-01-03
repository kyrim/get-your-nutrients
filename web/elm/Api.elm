module Api exposing (..)

import Http exposing (send, get, Error)
import Models exposing (Nutrient, Food)
import Json.Decode exposing (int, string, float, nullable, Decoder, list)
import Json.Encode exposing (string)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)


searchFoods : String -> (Result Error (List Food) -> a) -> Cmd a
searchFoods searchKey msg =
    let
        url =
            "api/food/search/" ++ searchKey

        request =
            Http.get url (list decodeFood)
    in
        Http.send msg request


getRecommendedFoods : List Food -> (Result Error (List Food) -> a) -> Cmd a
getRecommendedFoods foods msg =
    let
        url =
            "api/food/recommend"

        foodNames =
            (List.map
                (\food ->
                    Json.Encode.string food.foodId
                )
                foods
            )
                |> (Json.Encode.list)
                |> Http.jsonBody

        request =
            Http.post url foodNames (list decodeFood)
    in
        Http.send msg request


decodeNutrient : Decoder Nutrient
decodeNutrient =
    decode Nutrient
        |> required "nutrientId" Json.Decode.string
        |> required "name" Json.Decode.string
        |> required "percentage" int


decodeFood : Decoder Food
decodeFood =
    decode Food
        |> required "foodId" Json.Decode.string
        |> required "name" Json.Decode.string
        |> required "nutrients" (list decodeNutrient)
