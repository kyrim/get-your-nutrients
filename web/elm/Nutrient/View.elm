module Nutrient.View exposing (..)

import Dict exposing (..)
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
    { onHover : NutrientId -> Popover.State -> msg
    }


nutrientProgress : NutrientProgressConfig msg -> Bool -> Dict NutrientId Popover.State -> Nutrient -> Html msg
nutrientProgress config isHovered nutrientPopovers nutrient =
    let
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

        nutrientPopover =
            nutrientPopovers
                |> get nutrient.id
                |> Maybe.withDefault Popover.initialState

        popoverTitle =
            nutrient.name ++ " - " ++ toString nutrient.amount ++ " / " ++ toString nutrient.dailyIntake ++ nutrient.unitOfMeasure
    in
        div [ class [ AppCss.NutrientProgress ] ]
            [ Popover.config
                (div
                    (Popover.onHover nutrientPopover (config.onHover nutrient.id))
                    [ div []
                        [ span [] [ text nutrient.name ]
                        ]
                    , Progress.progressMulti
                        [ [ Progress.value hoverWidth, Progress.attr (style [ ( "background-color", "#b13fb8" ) ]) ]
                        , [ Progress.value percentageWidth, Progress.attr (style [ ( "background-color", percentageColour ) ]) ]
                        ]
                    ]
                )
                |> Popover.left
                |> Popover.title [ style [ ( "background-color", percentageColour ) ] ] [ text popoverTitle ]
                |> Popover.content [] [ text nutrient.description ]
                |> Popover.view nutrientPopover
            ]


nutrientSection : NutrientProgressConfig msg -> String -> Bool -> Dict NutrientId Popover.State -> List Nutrient -> Html msg
nutrientSection config category foodIsHovered nutrientPopovers nutrients =
    Grid.row []
        [ Grid.col []
            ([ h2 [] [ text category ] ]
                ++ (List.map
                        (nutrientProgress config foodIsHovered nutrientPopovers)
                        nutrients
                   )
            )
        ]
