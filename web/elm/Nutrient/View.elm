module Nutrient.View exposing (..)

import Helpers exposing (getPercentage)
import Nutrient.Models exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Bootstrap.Grid as Grid
import MainCss


getPercentageColour : Int -> String
getPercentageColour percentage =
    if percentage <= 20 then
        MainCss.nutrientLow
    else if percentage <= 50 then
        MainCss.nutrientMedium
    else if percentage <= 80 then
        MainCss.nutrientHigh
    else
        MainCss.nutrientFull


type alias NutrientProgressConfig msg =
    { mouseOver : Nutrient -> msg
    , mouseLeave : msg
    }


nutrientProgress : NutrientProgressConfig msg -> Bool -> Nutrient -> Html msg
nutrientProgress config isHovered nutrient =
    let
        label =
            nutrient.name

        hoverPercentage =
            getPercentage nutrient.hoveredAmount nutrient.dailyIntake

        percentage =
            getPercentage nutrient.amount nutrient.dailyIntake

        percentageToDisplay =
            if hoverPercentage > 0 then
                hoverPercentage
            else
                percentage

        hoverWidth =
            if (hoverPercentage > 100) then
                100
            else
                hoverPercentage

        percentageWidth =
            if (percentage > 100) then
                100 - hoverWidth
            else
                percentage - hoverWidth

        percentageColour =
            if (isHovered) then
                "lightgray"
            else
                getPercentageColour percentage

        displayColour =
            if (hoverWidth > 0) then
                "#b13fb8"
            else if (isHovered) then
                "lightgray"
            else
                percentageColour
    in
        div
            [ class "nutrient-progress"
            , onMouseOver (config.mouseOver nutrient)
            , onMouseLeave config.mouseLeave
            ]
            [ div [ class "progress-label" ]
                [ span [] [ text label ]
                , span
                    [ class "progress-percentage"
                    , style [ ( "color", displayColour ) ]
                    ]
                    [ text ((percentageToDisplay |> toString) ++ "%") ]
                ]
            , div
                [ class "progress" ]
                [ div
                    [ style
                        [ ( "width", (hoverWidth |> toString) ++ "%" )
                        , ( "background-color", "#b13fb8" )
                        ]
                    ]
                    []
                , div
                    [ style
                        [ ( "width", (percentageWidth |> toString) ++ "%" )
                        , ( "background-color", percentageColour )
                        ]
                    ]
                    []
                ]
            ]


nutrientSection : NutrientProgressConfig msg -> String -> Bool -> List Nutrient -> Html msg
nutrientSection config category foodIsHovered nutrients =
    Grid.row []
        [ Grid.col []
            ([ h2 [] [ text category ] ]
                ++ (List.map
                        (nutrientProgress config foodIsHovered)
                        nutrients
                   )
            )
        ]
