module BlazeHelpers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


-- Layout


gridWithCls : String -> List (Html a) -> Html a
gridWithCls cls contents =
    div [ class ("o-grid o-grid--wrap " ++ cls) ] contents


grid : List (Html a) -> Html a
grid contents =
    gridWithCls "" contents


cellWithCls : integer -> String -> List (Html a) -> Html a
cellWithCls width cls contents =
    div [ class ("o-grid__cell o-grid__cell--width-" ++ toString (width) ++ " " ++ cls) ] contents


cell : integer -> List (Html a) -> Html a
cell width contents =
    cellWithCls width "" contents


fullCell : List (Html a) -> Html a
fullCell contents =
    cell 100 contents


defaultCellWithCls : String -> List (Html a) -> Html a
defaultCellWithCls cls contents =
    div [ class ("o-grid__cell " ++ cls) ] contents


defaultCell : List (Html a) -> Html a
defaultCell contents =
    defaultCellWithCls "" contents



-- Headings


heading1 : String -> Html a
heading1 txt =
    h1 [ class "c-heading" ] [ text txt ]


heading2 : String -> Html a
heading2 txt =
    h2 [ class "c-heading" ] [ text txt ]


heading3 : String -> Html a
heading3 txt =
    h3 [ class "c-heading" ] [ text txt ]



-- Fields
