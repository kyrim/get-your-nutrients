module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Color exposing (..)


-- Model


type alias Model =
    List ( String, Int )


initialModel : Model
initialModel =
    [ ( "Biotin", 5 )
    , ( "Folate", 10 )
    , ( "Vitamin A", 15 )
    , ( "Vitamin B1", 16 )
    , ( "Vitamin B2", 12 )
    , ( "Vitamin B3", 13 )
    , ( "Vitamin B5", 17 )
    , ( "Vitamin B6", 35 )
    , ( "Vitamin B12", 32 )
    , ( "Vitamin C", 60 )
    , ( "Vitamin D", 100 )
    , ( "Vitamin E", 20 )
    , ( "Vitamin K", 50 )
    ]


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


topSection : Html Msg
topSection =
    div [ class "o-grid top-section" ]
        [ div [ class "o-grid__cell" ]
            [ banner ]
        , div [ class "o-grid__cell--offset" ]
            [ div [ class "about" ] [ h2 [ class "c-heading" ] [ a [ href "#about" ] [ text "About" ] ] ]
            ]
        ]


nutrientProgress : String -> Int -> Html Msg
nutrientProgress label percentage =
    let
        colour =
            if percentage <= 20 then
                "#FF3D7F"
            else if percentage <= 50 then
                "#FFAB2E"
            else if percentage <= 80 then
                "#7FC7AF"
            else
                "#6ABE6E"
    in
        div [ class "o-grid__cell" ]
            [ div [ class "progress-label" ]
                [ span [] [ text label ]
                , span
                    [ class "progress-percentage"
                    , style [ ( "color", colour ) ]
                    ]
                    [ text ((toString percentage) ++ "%") ]
                ]
            , div
                [ class "c-progress u-medium progress" ]
                [ div
                    [ class "c-progress__bar"
                    , style
                        [ ( "width", toString (percentage) ++ "%" )
                        , ( "background-color", colour )
                        ]
                    ]
                    []
                ]
            ]


createNutrientProgress : ( String, Int ) -> Html Msg
createNutrientProgress ( label, percentage ) =
    nutrientProgress label percentage


progressSection : Model -> Html Msg
progressSection model =
    div [ class "o-grid--large-fit" ]
        ([ div
            [ class "o-grid__cell" ]
            [ h2 [ class "c-heading" ] [ text "Vitamins" ] ]
         ]
            ++ (List.map
                    createNutrientProgress
                    model
               )
        )


view : Model -> Html Msg
view model =
    div []
        [ topSection
        , div
            [ class "o-grid" ]
            [ div [ class "o-grid__cell" ] [ progressSection model ]
            , div [ class "o-grid__cell" ] [ text "blah" ]
            , div [ class "o-grid__cell" ] [ text "blah" ]
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
