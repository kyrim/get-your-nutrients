module MainCss exposing (..)

import Css exposing (..)
import Css.Elements exposing (body, li)
import Css.Namespace exposing (namespace)


type CssClasses
    = NutrientLow
    | NutrientMedium
    | NutrientHigh
    | NutrientFull


css =
    stylesheet
        [ class NutrientLow [ color (hex nutrientLow) ]
        , class NutrientMedium [ color (hex nutrientMedium) ]
        , class NutrientHigh [ color (hex nutrientHigh) ]
        , class NutrientFull [ color (hex nutrientFull) ]
        ]



-- Colours


nutrientLow =
    "FF3D7F"


nutrientMedium =
    "FFAB2E"


nutrientHigh =
    "7FC7AF"


nutrientFull =
    "6ABE6E"
