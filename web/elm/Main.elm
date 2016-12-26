module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- Model


type alias Model =
    {}


initialModel : Model
initialModel =
    {}


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



-- MESSAGES


type Msg
    = None



-- View
-- Please note, stylesheet is already included.


banner : Html Msg
banner =
    div [ class "header" ]
        [ img [ class "o-image", src "images/logo.png" ] []
        , h1 [ class "c-heading" ] [ text "Get Your Nutrients" ]
        ]


view : Model -> Html Msg
view model =
    div [ class "o-grid top-section" ]
        [ div [ class "o-grid__cell" ]
            [ banner ]
        , div [ class "o-grid__cell--offset" ]
            [ div [ class "about" ] [ h2 [ class "c-heading" ] [ a [ href "#about" ] [ text "About" ] ] ]
            ]
        ]



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        None ->
            ( model, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- Init


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
