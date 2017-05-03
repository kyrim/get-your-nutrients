module Nutrient.Api exposing (..)

import Http exposing (send, get, Error)
import Helpers exposing (stringFloatDecoder)
import Nutrient.Models exposing (..)
import Json.Decode exposing (int, string, float, nullable, Decoder, list, map, andThen, succeed, fail)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)


getAllNutrients : (Result Error (List Nutrient) -> a) -> Cmd a
getAllNutrients msg =
    let
        url =
            "api/nutrient/"

        request =
            Http.get url (list decodeNutrient)
    in
        Http.send msg request


stringToNutrientType : String -> Decoder NutrientType
stringToNutrientType str =
    case str of
        "Vitamin" ->
            succeed Vitamin

        "Mineral" ->
            succeed Mineral

        _ ->
            fail ("Value " ++ str ++ "Is not a nutrient")


decodeNutrientType : Decoder NutrientType
decodeNutrientType =
    Json.Decode.string |> andThen stringToNutrientType


decodeNutrient : Decoder Nutrient
decodeNutrient =
    decode Nutrient
        |> required "id" Json.Decode.string
        |> required "name" Json.Decode.string
        |> required "description" Json.Decode.string
        |> optional "amount" Json.Decode.float 0
        |> optional "hoveredAmount" Json.Decode.float 0
        |> required "dailyIntake" stringFloatDecoder
        |> required "lowIntakeAmount" (nullable stringFloatDecoder)
        |> required "lowIntakeDescription" (nullable Json.Decode.string)
        |> required "highIntakeAmount" (nullable stringFloatDecoder)
        |> required "highIntakeDescription" (nullable Json.Decode.string)
        |> required "unitOfMeasure" Json.Decode.string
        |> required "nutrientType" decodeNutrientType
