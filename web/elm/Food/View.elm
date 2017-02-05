module Food.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import BlazeHelpers exposing (..)
import Html.Events exposing (..)
import Food.Models exposing (..)
import Connection.Models exposing (..)
import Connection.View exposing (..)
import Dict exposing (..)

type alias FoodRowConfig msg =
    { onFocus : FoodId -> msg
    , onBlur : msg
    , onRemove : FoodId -> msg
    , onQuantityChange : FoodId -> Int -> msg
    , onAmountChange : FoodId -> Int -> msg
    }


type alias SelectedFoodSectionConfig msg =
    { onClearAll : msg
    }


onInputToInt : FoodId -> Int -> (FoodId -> Int -> msg) -> (String -> msg)
onInputToInt food default onFunction =
    (\string -> onFunction food (string |> String.toInt |> Result.toMaybe |> Maybe.withDefault default))


foodRow : FoodRowConfig msg -> Food -> Html msg
foodRow { onFocus, onBlur, onRemove, onQuantityChange, onAmountChange } food =
    div
        [ class "c-card__item c-field c-field--choice food-item"
        , onMouseOver (onFocus food.id)
        , onMouseLeave onBlur
        ]
        [ div [ class "food-item-text" ] [ text food.name ]
        , div
            [ class "food-item-weight" ]
            [ div [ class "food-item-align" ]
                [ input
                    [ type_ "number"
                    , class "food-item-quantity"
                    , Html.Attributes.min "1"
                    , value (food.quantity |> toString)
                    , onInput (onInputToInt food.id 1 onQuantityChange)
                    ]
                    []
                , span
                    [ class "marker" ]
                    [ text "x" ]
                , input
                    [ type_ "number"
                    , class "food-item-amount"
                    , Html.Attributes.min "1"
                    , value (food.amount |> toString)
                    , onInput (onInputToInt food.id 100 onAmountChange)
                    ]
                    []
                , span
                    [ class "marker" ]
                    [ text "g" ]
                , a
                    [ class "selected-food-button" ]
                    [ i [ class "fa fa-times", onClick (onRemove food.id) ] []
                    ]
                ]
            ]
        ]


listWithOneItem : Html msg -> Html msg
listWithOneItem item =
    div [ class "c-card list-empty" ]
        [ div [ class "c-card-item list-empty-text" ]
            [  item
            ]
        ]


selectedFoodSection : SelectedFoodSectionConfig msg -> FoodRowConfig msg -> LoadState (Dict FoodId Food) -> Html msg
selectedFoodSection { onClearAll } foodRowConfig foods =
    let
        pleaseSearchFoodText =  listWithOneItem (text "Please search a food above")
        selectedFoodDisplay = 
        case foods of
            NotLoaded -> pleaseSearchFoodText
            Loading previousFoods -> listWithOneItem loadingImage
            Loaded loadedFoods -> 
                if Dict.isEmpty loadedFoods then
                    pleaseSearchFoodText
                else 
                div [ class "c-card c-card--menu food-menu" ]
                (List.map
                    (foodRow foodRowConfig)
                    (Dict.values loadedFoods)
                )       

    in
        grid
            [ fullCell
                [ h2 [ class "c-heading u-center-block smaller-tooltip" ]
                    [ text "Selected Food"
                    , a
                        [ class "selected-food-button c-tooltip c-tooltip--top"
                        , attribute "aria-label" "Clear all food"
                        , onClick onClearAll
                        ]
                        [ i [ class "fa fa-undo" ] []
                        ]
                    ]
                ]
            , fullCell
                [ selectedFoodDisplay
                ]
            ]


recommendedFoodRow : Food -> Html msg
recommendedFoodRow food =
    li [ class "c-card__item recommended-food-item" ]
        [ i [ class "fa fa-arrow-left recommended-icon" ]
            []
        , div [ class "recommended-text" ] [ text food.name ]
        ]


recommendedFoodSection : LoadState (List Food) -> Html msg
recommendedFoodSection recommendedFoods =
    let
        pleaseSearchFoodText =  listWithOneItem (text "Please search a food above")
        recommendedFoodDisplay = 
        case recommendedFoods of
            NotLoaded -> pleaseSearchFoodText
            Loading previousFoods -> listWithOneItem loadingImage
            Loaded loadedFoods -> 
                if List.isEmpty loadedFoods then
                    pleaseSearchFoodText
                else 
                div [ class "c-card c-card--menu food-menu" ]
                (List.map
                    recommendedFoodRow
                    loadedFoods
                ) 
    in
        grid
            [ fullCell
                [ h2 [ class "c-heading u-center-block smaller-tooltip" ]
                    [ text "Recommended" ]
                ]
            , fullCell
                [ recommendedFoodDisplay
                ]
            ]
