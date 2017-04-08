module Food.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Food.Models exposing (..)
import Connection.Models exposing (..)
import Connection.View exposing (..)
import Dict exposing (..)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row
import BootstrapHelper exposing (rowBuffer)
import AppCss


type alias FoodRowConfig msg =
    { onFocus : FoodId -> msg
    , onBlur : msg
    , onRemove : FoodId -> msg
    , onQuantityChange : FoodId -> Int -> msg
    , onAmountChange : FoodId -> Int -> msg
    }


type alias RecommendedFoodRowConfig msg =
    { onClick : Food -> msg
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
        [ onMouseOver (onFocus food.id)
        , onMouseLeave onBlur
        ]
        [ div [] [ text food.name ]
        , div
            []
            [ div []
                [ input
                    [ type_ "number"
                    , Html.Attributes.min "1"
                    , value (food.quantity |> toString)
                    , onInput (onInputToInt food.id 1 onQuantityChange)
                    ]
                    []
                , span
                    []
                    [ text "x" ]
                , input
                    [ type_ "number"
                    , Html.Attributes.min "1"
                    , value (food.amount |> toString)
                    , onInput (onInputToInt food.id 100 onAmountChange)
                    ]
                    []
                , span
                    []
                    [ text "g" ]
                , a
                    []
                    [ i [ onClick (onRemove food.id) ] []
                    ]
                ]
            ]
        ]


listWithOneItem : Html msg -> Html msg
listWithOneItem item =
    div []
        [ div []
            [ item
            ]
        ]


selectedFoodSection : SelectedFoodSectionConfig msg -> FoodRowConfig msg -> LoadState (Dict FoodId Food) -> Html msg
selectedFoodSection { onClearAll } foodRowConfig foods =
    let
        pleaseSearchFoodText =
            listWithOneItem (text "Please search a food above")

        selectedFoodDisplay =
            case foods of
                NotLoaded ->
                    pleaseSearchFoodText

                Loading previousFoods ->
                    listWithOneItem loadingImage

                Loaded loadedFoods ->
                    if Dict.isEmpty loadedFoods then
                        pleaseSearchFoodText
                    else
                        div []
                            (List.map
                                (foodRow foodRowConfig)
                                (Dict.values loadedFoods)
                            )
    in
        Grid.row [ rowBuffer ]
            [ Grid.col []
                [ h2 []
                    [ text "Selected Food"
                    , a
                        [ attribute "aria-label" "Clear all food"
                        , onClick onClearAll
                        ]
                        [ i [] []
                        ]
                    ]
                ]
            , Grid.col []
                [ selectedFoodDisplay
                ]
            ]


recommendedFoodRow : RecommendedFoodRowConfig msg -> Food -> Html msg
recommendedFoodRow config food =
    li []
        [ i []
            []
        , div [ onClick (config.onClick food) ] [ text food.name ]
        ]


recommendedFoodSection : RecommendedFoodRowConfig msg -> LoadState (List Food) -> Html msg
recommendedFoodSection config recommendedFoods =
    let
        pleaseSearchFoodText =
            listWithOneItem (text "Please search a food above")

        recommendedFoodDisplay =
            case recommendedFoods of
                NotLoaded ->
                    pleaseSearchFoodText

                Loading previousFoods ->
                    listWithOneItem loadingImage

                Loaded loadedFoods ->
                    if List.isEmpty loadedFoods then
                        pleaseSearchFoodText
                    else
                        div []
                            (List.map
                                (recommendedFoodRow config)
                                loadedFoods
                            )
    in
        Grid.row []
            [ Grid.col []
                [ h2 []
                    [ text "Recommended" ]
                ]
            , Grid.col []
                [ recommendedFoodDisplay
                ]
            ]
