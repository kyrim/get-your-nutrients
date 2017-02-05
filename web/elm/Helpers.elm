module Helpers exposing (..)

import Json.Decode exposing (float, Decoder, andThen, succeed, fail)


getPercentage : Float -> Float -> Int
getPercentage amount dailyIntake =
    (amount / dailyIntake * 100 |> round)


limitTo : Int -> Int -> Int
limitTo number limit =
    if number > limit then
        limit
    else
        number

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
