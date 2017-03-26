module Navigation.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Bootstrap.Grid as Grid
import Bootstrap.Navbar as Navbar


banner : Html msg
banner =
    div [ class "header" ]
        [ img [ class "o-image", src "images/logo.png" ] []
        , h1 [ class "c-heading" ] [ text "Get Your Nutrients" ]
        ]


topSection : Html msg
topSection =
    Grid.row []
        [ Grid.col [] [ banner ]
        , Grid.col []
            [ div [ class "about" ] [ h2 [ class "c-heading" ] [ a [ href "about" ] [ text "About" ] ] ]
            ]
        ]



-- topSection : msg -> Html msg
-- topSection msg =
--     Navbar.config msg
--         |> Navbar.withAnimation
--         |> Navbar.brand [ href "#" ] [ text "Brand" ]
--         |> Navbar.items
--             [ Navbar.itemLink [ href "#" ] [ text "Item 1" ]
--             , Navbar.itemLink [ href "#" ] [ text "Item 2" ]
--             ]
--         |> Navbar.view Navbar.initializeState
