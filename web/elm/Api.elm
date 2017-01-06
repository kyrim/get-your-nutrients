module Api exposing (..)

import Http exposing (send, get, Error)
import Models exposing (Nutrient, Food, FoodNutrient)
import Json.Decode exposing (int, string, float, nullable, Decoder, list, map, andThen, succeed, fail)
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


getFood : Int -> (Result Error Food -> a) -> Cmd a
getFood foodId msg =
    let
        url =
            "api/food/" ++ toString (foodId)

        request =
            Http.get url decodeFood
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
                    Json.Encode.int food.id
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
        |> required "id" Json.Decode.int
        |> required "name" Json.Decode.string
        |> required "percentage" int


decodeFoodNutrient : Decoder FoodNutrient
decodeFoodNutrient =
    decode FoodNutrient
        |> required "nutrientId" Json.Decode.int
        |> required "amount" stringFloatDecoder


decodeFood : Decoder Food
decodeFood =
    decode Food
        |> required "id" Json.Decode.int
        |> required "name" Json.Decode.string
        |> required "foodNutrients" (list decodeFoodNutrient)



-- Helpers


stringFloatDecoder : Decoder Float
stringFloatDecoder =
    (Json.Decode.string)
        |> andThen
            (\val ->
                case String.toFloat val of
                    Ok f ->
                        succeed f

                    Err e ->
                        fail e
            )
