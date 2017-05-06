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
import Bootstrap.ListGroup as ListGroup
import BootstrapHelper exposing (rowBuffer)
import AppCss
import FontAwesome.Web as Icon
import Html.CssHelpers


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


{ id, class, classList } =
    Html.CssHelpers.withNamespace ""


onInputToInt : FoodId -> Int -> (FoodId -> Int -> msg) -> (String -> msg)
onInputToInt food default onFunction =
    (\string -> onFunction food (string |> String.toInt |> Result.toMaybe |> Maybe.withDefault default))


foodRow : FoodRowConfig msg -> Food -> ListGroup.CustomItem msg
foodRow { onFocus, onBlur, onRemove, onQuantityChange, onAmountChange } food =
    ListGroup.anchor [ ListGroup.attrs [ class [ AppCss.FoodRow ] ] ]
        [ div
            [ onMouseOver (onFocus food.id)
            , onMouseLeave onBlur
            , class [ AppCss.FoodContainer ]
            ]
            [ div [ class [ AppCss.FoodLeftSection ] ] [ text food.name ]
            , div
                [ class [ AppCss.FoodRightSection ] ]
                [ div [ class [ AppCss.FoodInputs ] ]
                    [ input
                        [ type_ "number"
                        , Html.Attributes.min "1"
                        , class [ AppCss.QuantityFoodInput ]
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
                        , class [ AppCss.AmountFoodInput ]
                        , value (food.amount |> toString)
                        , onInput (onInputToInt food.id 100 onAmountChange)
                        ]
                        []
                    , span
                        []
                        [ text "g" ]
                    , a
                        []
                        [ i [ onClick (onRemove food.id), class [ AppCss.FoodDelete ] ] [ Icon.times ]
                        ]
                    ]
                ]
            ]
        ]


listWithOneItem : Html msg -> ListGroup.CustomItem msg
listWithOneItem item =
    ListGroup.anchor [ ListGroup.disabled ] [ item ]


selectedFoodSection : SelectedFoodSectionConfig msg -> FoodRowConfig msg -> LoadState (Dict FoodId Food) -> Html msg
selectedFoodSection { onClearAll } foodRowConfig foods =
    let
        pleaseSearchFoodText =
            listWithOneItem (text "Please search for a food above")

        selectedFoodDisplay =
            case foods of
                NotLoaded ->
                    [ pleaseSearchFoodText ]

                Loading previousFoods ->
                    [ listWithOneItem loadingImage ]

                Loaded loadedFoods ->
                    if Dict.isEmpty loadedFoods then
                        [ pleaseSearchFoodText ]
                    else
                        List.map
                            (foodRow foodRowConfig)
                            (Dict.values loadedFoods)
    in
        Grid.row [ rowBuffer ]
            [ Grid.col []
                [ div [ class [ AppCss.SelectedFoodHeader ] ]
                    [ h2 [ class [ AppCss.SelectedFoodTitle ] ]
                        [ text "Selected Food"
                        ]
                    , a
                        [ onClick onClearAll
                        , class [ AppCss.ClearAll ]
                        ]
                        [ div [] [ text "Clear All" ]
                        ]
                    ]
                , div [ class [ AppCss.FoodList ] ] [ ListGroup.custom selectedFoodDisplay ]
                ]
            ]
