module Nutrient.View exposing (..)

import Helpers exposing (getPercentage)
import Nutrient.Models exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import BlazeHelpers exposing (..)


getPercentageColour : Int -> String
getPercentageColour percentage =
    if percentage <= 20 then
        "#FF3D7F"
    else if percentage <= 50 then
        "#FFAB2E"
    else if percentage <= 80 then
        "#7FC7AF"
    else
        "#6ABE6E"


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
            [ class "o-grid__cell o-grid__cell--width-100 nutrient-progress"
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
                [ class "c-progress u-medium progress" ]
                [ div
                    [ class "c-progress__bar"
                    , style
                        [ ( "width", (hoverWidth |> toString) ++ "%" )
                        , ( "background-color", "#b13fb8" )
                        ]
                    ]
                    []
                , div
                    [ class "c-progress__bar"
                    , style
                        [ ( "width", (percentageWidth |> toString) ++ "%" )
                        , ( "background-color", percentageColour )
                        ]
                    ]
                    []
                ]
            ]


nutrientSection : NutrientProgressConfig msg -> String -> Bool -> List Nutrient -> Html msg
nutrientSection config category foodIsHovered nutrients =
    gridWithCls "large-fit"
        ([ fullCell [ heading2 category ]
         ]
            ++ (List.map
                    (nutrientProgress
                        config
                        foodIsHovered
                    )
                    nutrients
               )
        )
