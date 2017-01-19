module Navigation.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import BlazeHelpers exposing (..)


banner : Html msg
banner =
    div [ class "header" ]
        [ img [ class "o-image", src "images/logo.png" ] []
        , h1 [ class "c-heading" ] [ text "Get Your Nutrients" ]
        ]


topSection : Html msg
topSection =
    grid
        [ defaultCell
            [ banner ]
        , div [ class "o-grid__cell--offset" ]
            [ div [ class "about" ] [ h2 [ class "c-heading" ] [ a [ href "about" ] [ text "About" ] ] ]
            ]
        ]
