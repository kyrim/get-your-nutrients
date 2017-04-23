module AppCss exposing (..)

import Css exposing (..)
import Css.Elements exposing (body, img, li, div, input)


type CssClasses
    = Content
    | NutrientLow
    | NutrientMedium
    | NutrientHigh
    | NutrientFull
    | RowBuffer
    | NiceShadow
    | NutrientProgress
    | PopoverNutrient
    | SearchInput
    | SearchResults
    | SelectedFoodHeader
    | SelectedFoodTitle
    | ClearAll
    | FoodList
    | FoodDelete
    | FoodInputs
    | FoodContainer
    | FoodBottomSection
    | Clickable


css : Stylesheet
css =
    stylesheet
        [ class Content [ marginTop (px 80) ]
        , class NutrientLow [ color (hex nutrientLow) ]
        , class NutrientMedium [ color (hex nutrientMedium) ]
        , class NutrientHigh [ color (hex nutrientHigh) ]
        , class NutrientFull [ color (hex nutrientFull) ]
        , class RowBuffer [ marginTop (Css.rem 1) ]
        , class NiceShadow [ boxShadow4 (px 0) (px 6) (px 6) (rgba 0 0 0 0.16), boxShadow4 (px 0) (px 6) (px 6) (rgba 0 0 0 0.23) ]
        , class SearchResults [ position absolute, zIndex 200, left zero, right zero ]
        , class SearchInput [ zIndex 0 |> important ]
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
        , class SelectedFoodHeader
            [ width (pct 100)
            , verticalAlign middle
            ]
        , class SelectedFoodTitle
            [ float left
            ]
        , class ClearAll
            [ float right
            , cursor pointer
            , opacity (num 0.7)
            , hover
                [ opacity (num 1)
                , transform (scale 1.07)
                , transition "all" "0.2s" "ease"
                ]
            ]
        , class FoodList
            [ height (em 30)
            , maxHeight (em 30)
            , width (pct 100)
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
        , class Clickable
            [ cursor pointer
            ]
        ]



-- Colours


nutrientLow : String
nutrientLow =
    "#FF2020"


nutrientMedium : String
nutrientMedium =
    "#FFAB2E"


nutrientHigh : String
nutrientHigh =
    "#7FC7AF"


nutrientFull : String
nutrientFull =
    "#6ABE6E"



-- Custom Properties


transition : String -> String -> String -> Mixin
transition first second third =
    property "transition" (first ++ " " ++ second ++ " " ++ third)


zIndex : Int -> Mixin
zIndex i =
    property "z-index" <| toString i
