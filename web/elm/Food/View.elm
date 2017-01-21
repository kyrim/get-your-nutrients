module Food.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import BlazeHelpers exposing (..)
import Html.Events exposing (..)
import Food.Models exposing (..)
import Json.Decode as Json


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


emptyList : String -> Html msg
emptyList message =
    div [ class "c-card list-empty" ]
        [ div [ class "c-card-item list-empty-text" ]
            [ text message
            ]
        ]


selectedFoodSection : SelectedFoodSectionConfig msg -> FoodRowConfig msg -> List Food -> Html msg
selectedFoodSection { onClearAll } foodRowConfig foods =
    let
        displaySelectedFoodMenu =
            (List.length foods) > 0

        selectedFoodMenu =
            div [ class "c-card c-card--menu" ]
                (List.map
                    (foodRow foodRowConfig)
                    foods
                )

        selectedFoodDisplay =
            if displaySelectedFoodMenu then
                selectedFoodMenu
            else
                emptyList "Please search a food above"
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
    li [ class "c-card__item food-item" ]
        [ i [ class "fa fa-arrow-left" ]
            []
        , text food.name
        ]


recommendedFoodSection : List Food -> Html msg
recommendedFoodSection recommendedFoods =
    let
        displayRecommendedFoodMenu =
            (List.length recommendedFoods) > 0

        recommendedFoodMenu =
            ul [ class "c-card c-card--menu" ]
                (List.map
                    recommendedFoodRow
                    recommendedFoods
                )

        recommendedFoodDisplay =
            if displayRecommendedFoodMenu then
                recommendedFoodMenu
            else
                emptyList "Please search a food above"
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
