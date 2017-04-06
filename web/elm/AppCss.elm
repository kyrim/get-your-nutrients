module AppCss exposing (..)

import Css exposing (..)
import Css.Elements exposing (body, img, li)
import Css.Namespace exposing (namespace)


type CssClasses
    = Header
    | NutrientLow
    | NutrientMedium
    | NutrientHigh
    | NutrientFull


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
