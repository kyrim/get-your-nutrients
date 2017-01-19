module Food.Api exposing (..)

import Http exposing (send, get, Error)
import Helpers exposing (stringFloatDecoder)
import Food.Models exposing (..)
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
        |> optional "amount" Json.Decode.int 100
        |> optional "quantity" Json.Decode.int 1
        |> required "foodNutrients" (list decodeFoodNutrient)
