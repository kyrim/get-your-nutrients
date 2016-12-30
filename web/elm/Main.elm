module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Api exposing (..)
import Http exposing (..)
import Models exposing (..)
import BlazeHelpers exposing (..)


-- Model


type alias Model =
    { vitamins : List Nutrient
    , minerals : List Nutrient
    , selectedFoods : List Food
    , potentialFoods : List Food
    , recommendedFoods : List Food
    }


nu : ( String, Int ) -> Nutrient
nu ( name, percentage ) =
    { nutrientId = name
    , name = name
    , percentage = percentage
    }


initialModel : Model
initialModel =
    { vitamins =
        [ nu ( "Biotin", 5 )
        , nu ( "Folate", 10 )
        , nu ( "Vitamin A", 15 )
        , nu ( "Vitamin B1", 16 )
        , nu ( "Vitamin B2", 12 )
        , nu ( "Vitamin B3", 13 )
        , nu ( "Vitamin B5", 17 )
        , nu ( "Vitamin B6", 35 )
        , nu ( "Vitamin B12", 32 )
        , nu ( "Vitamin C", 60 )
        , nu ( "Vitamin D", 100 )
        , nu ( "Vitamin E", 20 )
        , nu ( "Vitamin K", 50 )
        ]
    , minerals =
        [ nu ( "Boron", 5 )
        , nu ( "Calcium", 10 )
        , nu ( "Chromium", 10 )
        , nu ( "Copper", 10 )
        , nu ( "Fluorine", 20 )
        ]
    , selectedFoods = [ { foodId = "40", name = "Apple", nutrients = [] } ]
    , potentialFoods = []
    , recommendedFoods = [ { foodId = "40", name = "Orange", nutrients = [] } ]
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



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
    grid
        [ defaultCell
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

        percentageStr =
            toString percentage
    in
        div [ class "o-grid__cell o-grid__cell--width-100 nutrient-progress" ]
            [ div [ class "progress-label" ]
                [ span [] [ text label ]
                , span
                    [ class "progress-percentage"
                    , style [ ( "color", colour ) ]
                    ]
                    [ text (percentageStr ++ "%") ]
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
createNutrientProgress nutrient =
    nutrientProgress nutrient.name nutrient.percentage


nutrientSection : List Nutrient -> String -> Html Msg
nutrientSection nutrients category =
    gridWithCls "large-fit"
        ([ fullCell [ heading2 category ]
         ]
            ++ (List.map
                    createNutrientProgress
                    nutrients
               )
        )


foodRow : Food -> Html Msg
foodRow food =
    div []
        [ label [ class "c-card__item c-field c-field--choice food-item" ]
            [ input [ type_ "checkbox" ] []
            , text food.name
            ]
        ]


selectedFoodSection : List Food -> Html Msg
selectedFoodSection foods =
    grid
        [ fullCell
            [ h2 [ class "c-heading u-center-block smaller-tooltip" ]
                [ text "Selected Food"
                , a
                    [ class "selected-food-button c-tooltip c-tooltip--top"
                    , attribute "aria-label" "Clear all food"
                    ]
                    [ i [ class "fa fa-undo" ] []
                    ]
                , a
                    [ class "selected-food-button c-tooltip c-tooltip--top"
                    , attribute "aria-label" "Remove selected food"
                    ]
                    [ i [ class "fa fa-times" ] []
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


recommendedFoodRow : Food -> Html Msg
recommendedFoodRow food =
    li [ class "c-card__item food-item" ]
        [ i [ class "fa fa-arrow-left" ]
            []
        , text food.name
        ]


recommendedFoodSection : List Food -> Html Msg
recommendedFoodSection recommendedFoods =
    grid
        [ fullCell
            [ h2 [ class "c-heading u-center-block smaller-tooltip" ]
                [ text "Recommended" ]
            ]
        , fullCell
            [ ul [ class "c-card c-card--menu" ]
                (List.map
                    recommendedFoodRow
                    recommendedFoods
                )
            ]
        ]


informationSection : String -> String -> Html Msg
informationSection heading info =
    grid
        [ fullCell
            [ div
                [ class "c-card u-high" ]
                [ div [ class "c-card__item info-panel-header" ]
                    [ text heading ]
                , div [ class "c-card__item" ]
                    [ div [ class "c-paragraph info-panel-text" ]
                        [ text info
                        ]
                    ]
                ]
            ]
        ]


searchBar : List Food -> Html Msg
searchBar potentialFoods =
    div [ class "search-holder" ]
        [ fullCell
            [ div [ class "o-field o-field--icon-right" ]
                [ input
                    [ class "c-field"
                    , placeholder "Search for food here and add to calculate nutrients"
                    , onInput FindFood
                    ]
                    []
                , i [ class "a fa fa-search c-icon" ] []
                ]
            ]
        , div
            [ class "search-dropdown" ]
            [ ul [ class "c-card c-card--menu u-high " ]
                (List.map (\x -> li [ class "c-card__item" ] [ text x.name ]) potentialFoods)
            ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ topSection
        , grid
            [ cell 50
                [ defaultCellWithCls "u-letter-box--small" [ searchBar model.potentialFoods ]
                , grid
                    [ defaultCell [ selectedFoodSection model.selectedFoods ]
                    , defaultCell [ recommendedFoodSection model.recommendedFoods ]
                    ]
                ]
            , defaultCell
                [ nutrientSection model.vitamins "Vitamins (DI%)"
                , nutrientSection model.minerals "Minerals (DI%)"
                ]
            , defaultCell
                [ heading2 ""
                , informationSection "Nothing Selected" "Please add food to begin calculating."
                ]
            ]
        ]



-- MESSAGES


type Msg
    = FindFood String
    | FoundFoods (Result Http.Error (List Food))



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        FindFood food ->
            ( model, (findFoods food FoundFoods) )

        FoundFoods (Ok foods) ->
            ( { model | potentialFoods = foods }, Cmd.none )

        FoundFoods (Err _) ->
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
