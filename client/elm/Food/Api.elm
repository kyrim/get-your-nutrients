module Food.Api exposing (..)

import Http exposing (send, get, Error)
import Helpers exposing (stringFloatDecoder)
import Food.Models exposing (..)
import Json.Decode exposing (int, string, float, nullable, Decoder, list, map, andThen, succeed, fail)
import Json.Encode exposing (string)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)


getFood : String -> (Result Error Food -> a) -> Cmd a
getFood foodId msg =
    let
        url =
            "api/food/" ++ foodId

        request =
            Http.get url decodeFood
    in
        Http.send msg request


decodeFoodNutrient : Decoder FoodNutrient
decodeFoodNutrient =
    decode FoodNutrient
        |> required "nutrientId" Json.Decode.string
        |> required "amount" Json.Decode.float


decodeFood : Decoder Food
decodeFood =
    decode Food
        |> required "id" Json.Decode.string
        |> required "name" Json.Decode.string
        |> optional "amount" Json.Decode.int 100
        |> optional "quantity" Json.Decode.int 1
        |> required "foodNutrients" (list decodeFoodNutrient)
