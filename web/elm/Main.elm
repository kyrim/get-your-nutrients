module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import BlazeHelpers exposing (..)


-- Model


type alias Nutrient =
    ( String, Int )


type alias Model =
    { vitamins : List Nutrient
    , minerals : List Nutrient
    }


initialModel : Model
initialModel =
    { vitamins =
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
    , minerals =
        [ ( "Boron", 5 )
        , ( "Calcium", 10 )
        , ( "Chromium", 10 )
        , ( "Copper", 10 )
        , ( "Fluorine", 20 )
        ]
    }


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
            [ div [ class "about" ] [ h2 [ class "c-heading" ] [ a [ href "about" ] [ text "About" ] ] ]
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
        div [ class "o-grid__cell nutrient-progress" ]
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


createNutrientProgress : Nutrient -> Html Msg
createNutrientProgress ( label, percentage ) =
    nutrientProgress label percentage


nutrientSection : List Nutrient -> String -> Html Msg
nutrientSection nutrients category =
    gridWithCls "large-fit"
        ([ defaultCell [ heading2 category ]
         ]
            ++ (List.map
                    createNutrientProgress
                    nutrients
               )
        )


foodRow : String -> Html Msg
foodRow food =
    label [ class "c-card__item c-field c-field--choice food-item" ]
        [ input [ type_ "checkbox" ] []
        , text food
        ]


selectedFoodsSection : List String -> Html Msg
selectedFoodsSection foods =
    grid
        [ fullCell
            [ h2 [ class "c-heading u-center-block" ]
                [ text "Selected Foods"
                , a [ class "reset-button" ]
                    [ i [ class "fa fa-undo", title "Clear all foods" ] []
                    ]
                ]
            ]
        , fullCell
            [ div [ class "c-card c-card--menu" ]
                (List.map
                    foodRow
                    foods
                )
            ]
        ]


informationSection : String -> String -> Html Msg
informationSection heading info =
    grid
        [ fullCell
            [ div
                [ class "c-card u-high" ]
                [ div [ class "c-card__item c-card__item--info" ]
                    [ text heading ]
                , div [ class "c-card__item" ]
                    [ div [ class "c-paragraph info-panel-text" ]
                        [ text info
                        ]
                    ]
                ]
            ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ topSection
        , grid
            [ cell 50
                [ defaultCellWithCls "u-letter-box--small"
                    [ div [ class "o-field o-field--icon-right" ]
                        [ input [ class "c-field", placeholder "Search here to add foods and calculate nutrients" ] []
                        , i [ class "a fa fa-search c-icon" ] []
                        ]
                    ]
                , grid
                    [ defaultCell [ selectedFoodsSection [ "apple" ] ]
                    , defaultCell [ heading2 "Recommended" ]
                    ]
                ]
            , defaultCell
                [ nutrientSection model.vitamins "Vitamins (DI%)"
                , nutrientSection model.minerals "Minerals (DI%)"
                ]
            , defaultCell
                [ heading2 ""
                , informationSection "Nothing Selected" "Please add foods to begin calculating."
                ]
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
