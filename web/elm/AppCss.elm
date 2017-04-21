module AppCss exposing (..)

import Css exposing (..)
import Css.Elements exposing (body, img, li, div, input)
import Css.Namespace exposing (namespace)


type CssClasses
    = Content
    | NutrientLow
    | NutrientMedium
    | NutrientHigh
    | NutrientFull
    | RowBuffer
    | NutrientProgress
    | PopoverNutrient
    | SearchInput
    | SearchResults
    | FoodList
    | FoodDelete
    | FoodInputs
    | FoodContainer
    | FoodBottomSection


css =
    stylesheet
        [ class Content [ marginTop (px 60) ]
        , class NutrientLow [ color (hex nutrientLow) ]
        , class NutrientMedium [ color (hex nutrientMedium) ]
        , class NutrientHigh [ color (hex nutrientHigh) ]
        , class NutrientFull [ color (hex nutrientFull) ]
        , class RowBuffer [ marginTop (Css.rem 1) ]
        , class SearchResults [ position absolute, zIndex 200, left zero, right zero ]
        , class SearchInput [ zIndex 0 ]
        , class PopoverNutrient
            [ width (pct 100)
            ]
        , class NutrientProgress
            [ marginBottom (em 0.5)
            , cursor pointer
            , opacity (num 0.7)
            , hover
                [ opacity (num 1)
                , transform (scale 1.07)
                , transition "all" "0.2s" "ease"
                ]
            , children
                -- Doing this to hack the ELM bootstrap popovers to allow full width
                [ div
                    [ (display block) |> important
                    ]
                ]
            ]
        , class FoodList
            [ height (em 30)
            , maxHeight (em 30)
            , overflowY auto
            , backgroundColor (rgb 254 254 254)
            , border3 (px 1) solid (rgb 240 240 240)
            , borderRadius (em 0.25)
            ]
        , class FoodDelete
            [ cursor pointer
            , marginLeft (em 0.5)
            ]
        , class FoodBottomSection
            [ borderTop3 (px 1) solid (rgb 232 232 232)
            , marginTop (em 0.5)
            , width (pct 100)
            ]
        , class FoodInputs
            [ padding (em 0.5)
            , float right
            , children
                [ input [ width (em 4), marginRight (em 0.25) ]
                ]
            ]
        , class FoodContainer
            [ width (pct 100)
            ]
        ]



-- Colours


nutrientLow =
    "#FF2020"


nutrientMedium =
    "#FFAB2E"


nutrientHigh =
    "#7FC7AF"


nutrientFull =
    "#6ABE6E"



-- Custom Properties


transition : String -> String -> String -> Mixin
transition first second third =
    property "transition" (first ++ " " ++ second ++ " " ++ third)


zIndex : Int -> Mixin
zIndex i =
    property "z-index" <| toString i
