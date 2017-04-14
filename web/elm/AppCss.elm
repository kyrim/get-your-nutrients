module AppCss exposing (..)

import Css exposing (..)
import Css.Elements exposing (body, img, li, div)
import Css.Namespace exposing (namespace)


type CssClasses
    = Header
    | NutrientLow
    | NutrientMedium
    | NutrientHigh
    | NutrientFull
    | RowBuffer
    | NutrientProgress
    | PopoverNutrient
    | SearchResults


css =
    stylesheet
        [ class Header
            [ overflow hidden
            , display table
            , marginTop (em 1)
            , children
                [ img
                    [ margin2 zero auto
                    , float left
                    , width (px 100)
                    , height (px 100)
                    ]
                ]
            ]
        , class NutrientLow [ color (hex nutrientLow) ]
        , class NutrientMedium [ color (hex nutrientMedium) ]
        , class NutrientHigh [ color (hex nutrientHigh) ]
        , class NutrientFull [ color (hex nutrientFull) ]
        , class RowBuffer [ marginTop (Css.rem 1) ]
        , class SearchResults [ position absolute, zIndex 9999, width (pct 100) ]
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
        ]



-- Colours


nutrientLow =
    "#FF3D7F"


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
