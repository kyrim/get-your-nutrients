module Nutrient.View exposing (..)

import Helpers exposing (getPercentage)
import Nutrient.Models exposing (..)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (..)
import Bootstrap.Grid as Grid
import Bootstrap.Progress as Progress
import Bootstrap.Popover as Popover
import Html.CssHelpers
import AppCss


{ id, class, classList } =
    Html.CssHelpers.withNamespace ""


getPercentageColour : Int -> String
getPercentageColour percentage =
    if percentage <= 20 then
        AppCss.nutrientLow
    else if percentage <= 50 then
        AppCss.nutrientMedium
    else if percentage <= 80 then
        AppCss.nutrientHigh
    else
        AppCss.nutrientFull


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
            [ class [ AppCss.NutrientProgress ]
            , onMouseOver (config.mouseOver nutrient)
            , onMouseLeave config.mouseLeave
            ]
            [ div []
                [ span [] [ text label ]
                ]
            , Progress.progressMulti
                [ [ Progress.value hoverWidth, Progress.attr (style [ ( "background-color", "#b13fb8" ) ]) ]
                , [ Progress.value percentageWidth, Progress.attr (style [ ( "background-color", percentageColour ) ]) ]
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
