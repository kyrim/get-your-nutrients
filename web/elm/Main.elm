module Main exposing (..)

-- Elm Specific

import Dict exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import BlazeHelpers exposing (..)
import Helpers exposing (..)
import Nutrient.View exposing (..)
import Nutrient.Models exposing (..)
import Nutrient.Api exposing (..)
import Food.View exposing (..)
import Food.Models exposing (..)
import Food.Api exposing (..)
import Navigation.View exposing (..)
import Connection.View exposing (..)
import Connection.Models exposing (..)


-- Model


type HoverItem
    = Nutrient Nutrient
    | Food FoodId
    | NothingHovered


type alias Model =
    { nutrients : Dict NutrientId Nutrient
    , searchText : String
    , selectedFoods : Dict FoodId Food
    , potentialFoods : List Food
    , recommendedFoods : List Food
    , hoverItem : HoverItem
    , connectionModalState : ModalState
    }


initialModel : Model
initialModel =
    { searchText = ""
    , nutrients = Dict.empty
    , selectedFoods = Dict.empty
    , potentialFoods = []
    , recommendedFoods = []
    , hoverItem = NothingHovered
    , connectionModalState = Hide
    }


init : ( Model, Cmd Msg )
init =
    initialModel ! [ getAllNutrients GotNutrients ]



-- View
-- Please note, stylesheet is already included.


informationSection : HoverItem -> Dict FoodId Food -> Html Msg
informationSection hoverItem foodDict =
    let
        header =
            case hoverItem of
                NothingHovered ->
                    "Summary"

                Nutrient nutrient ->
                    nutrient.name

                Food foodId ->
                    case (Dict.get foodId foodDict) of
                        Nothing ->
                            ""

                        Just food ->
                            food.name

        sideHeader =
            case hoverItem of
                NothingHovered ->
                    ""

                Nutrient nutrient ->
                    (nutrient.amount |> toString) ++ " / " ++ (nutrient.dailyIntake |> toString) ++ "" ++ nutrient.unitOfMeasure

                Food foodId ->
                    ""

        info =
            case hoverItem of
                NothingHovered ->
                    "Please hover over a food or nutrient to view its summary."

                Nutrient nutrient ->
                    nutrient.description

                Food food ->
                    "The purple section on the progress bars below on each nutrient, shows the perentage of nutrients from the food."

        colour =
            case hoverItem of
                NothingHovered ->
                    "#3f9cb8"

                Nutrient nutrient ->
                    nutrient.dailyIntake |> getPercentage nutrient.amount |> getPercentageColour

                Food food ->
                    "#b13fb8"
    in
        grid
            [ fullCell
                [ div
                    [ class "c-card info-panel" ]
                    [ div
                        [ class "c-card__item info-panel-header"
                        , style
                            [ ( "background-color", colour )
                            ]
                        ]
                        [ div [ class "info-panel-header-text" ] [ text header ]
                        , div [ class "info-panel-side-header" ] [ text sideHeader ]
                        ]
                    , div [ class "c-card__item" ]
                        [ div [ class "c-paragraph info-panel-text" ]
                            [ text info
                            ]
                        ]
                    ]
                ]
            ]


searchBar : String -> List Food -> Html Msg
searchBar searchText potentialFoods =
    div [ class "search-holder" ]
        [ fullCell
            [ div [ class "o-field o-field--icon-right" ]
                [ input
                    [ class "c-field"
                    , placeholder "Search for food here and add to calculate nutrients"
                    , value searchText
                    , onInput UpdateSearchText
                    , onBlur ClearSearch
                    ]
                    []
                , i [ class "a fa fa-search c-icon" ] []
                ]
            ]
        , div
            [ class "search-dropdown u-pillar-box--large" ]
            [ ul [ class "c-card c-card--menu u-high" ]
                (List.map
                    (\food ->
                        li [ class "c-card__item", onMouseDown (SelectFood food) ]
                            [ text food.name ]
                    )
                    potentialFoods
                )
            ]
        ]


getFoodFromHoverItem : HoverItem -> Maybe FoodId
getFoodFromHoverItem item =
    case item of
        NothingHovered ->
            Nothing

        Nutrient nutrient ->
            Nothing

        Food food ->
            Just food



-- MESSAGES


type Msg
    = ClearSearch
    | UpdateSearchText String
    | ClearAllSelected
    | FoundFoods (Result Http.Error (List Food))
    | SelectFood Food
    | GotFood (Result Http.Error Food)
    | FoundRecommendedFoods (Result Http.Error (List Food))
    | GotNutrients (Result Http.Error (List Nutrient))
    | UpdateFoodQuantity FoodId Int
    | UpdateFoodAmount FoodId Int
    | RemoveFood FoodId
    | Hover HoverItem
    | ConnectionModal ModalState


selectedFoodSectionConfig : SelectedFoodSectionConfig Msg
selectedFoodSectionConfig =
    { onClearAll = ClearAllSelected }


foodRowConfig : FoodRowConfig Msg
foodRowConfig =
    { onFocus = Hover << Food
    , onBlur = Hover NothingHovered
    , onRemove = RemoveFood
    , onQuantityChange = UpdateFoodQuantity
    , onAmountChange = UpdateFoodAmount
    }


view : Model -> Html Msg
view model =
    div []
        [ topSection
        , grid
            [ cell 50
                [ defaultCellWithCls "u-letter-box--small" [ searchBar model.searchText model.potentialFoods ]
                , grid
                    [ cell 60 [ model.selectedFoods |> Dict.values |> selectedFoodSection selectedFoodSectionConfig foodRowConfig ]
                    , cell 40 [ recommendedFoodSection model.recommendedFoods ]
                    ]
                ]
            , defaultCell
                [ grid
                    [ fullCell [ informationSection model.hoverItem model.selectedFoods ]
                    , cell 50
                        [ nutrientSection
                            { mouseOver = Hover << Nutrient, mouseLeave = Hover NothingHovered }
                            "Vitamins (DI%)"
                            (hoverItemIsFood model.hoverItem)
                            (model.nutrients
                                |> filterNutrient Vitamin
                                |> calculateNutrientPercentageFromFoods (getFoodFromHoverItem (model.hoverItem)) model.selectedFoods
                                |> Dict.values
                            )
                        ]
                    , cell 50
                        [ nutrientSection
                            { mouseOver = Hover << Nutrient, mouseLeave = Hover NothingHovered }
                            "Minerals (DI%)"
                            (hoverItemIsFood model.hoverItem)
                            (model.nutrients
                                |> filterNutrient Mineral
                                |> calculateNutrientPercentageFromFoods (getFoodFromHoverItem (model.hoverItem)) model.selectedFoods
                                |> Dict.values
                            )
                        ]
                    ]
                ]
            ]
        , connectionError { onClose = (ConnectionModal Hide) } model.connectionModalState
        ]


hoverItemIsFood : HoverItem -> Bool
hoverItemIsFood item =
    case item of
        Nutrient nutrient ->
            False

        Food food ->
            True

        NothingHovered ->
            False


calculateNutrientPercentageFromFoods : Maybe FoodId -> Dict FoodId Food -> Dict NutrientId Nutrient -> Dict NutrientId Nutrient
calculateNutrientPercentageFromFoods hoveredFoodId foods nutrients =
    let
        food =
            case hoveredFoodId of
                Nothing ->
                    Nothing

                Just foodId ->
                    case foods |> Dict.get foodId of
                        Nothing ->
                            Maybe.Nothing

                        Just food ->
                            Just food
    in
        Dict.map
            (\nutrientId nutrient ->
                { nutrient
                    | amount = (foods |> Dict.values |> List.map (\food -> getNutrientFoodAmountById nutrient.id food) |> List.sum)
                    , hoveredAmount =
                        case hoveredFoodId of
                            Nothing ->
                                0

                            Just foodId ->
                                case foods |> Dict.get foodId of
                                    Nothing ->
                                        0

                                    Just food ->
                                        getNutrientFoodAmountById nutrient.id food
                }
            )
            nutrients


getNutrientFoodAmountById : Int -> Food -> Float
getNutrientFoodAmountById id food =
    food.nutrients
        |> List.filter (\fn -> fn.nutrientId == id)
        |> List.map (\fn -> fn.amount * toFloat food.amount * toFloat food.quantity)
        |> List.sum


filterNutrient : NutrientType -> Dict NutrientId Nutrient -> Dict NutrientId Nutrient
filterNutrient nutrientType nutrients =
    nutrients
        |> Dict.filter (\nutrientId nutrient -> nutrient.nutrientType == nutrientType)



-- Update


showConnectionError : Model -> ( Model, Cmd Msg )
showConnectionError model =
    { model
        | connectionModalState = Show
    }
        ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ClearSearch ->
            { model | potentialFoods = [] } ! []

        UpdateSearchText text ->
            if ((text |> String.trim |> String.isEmpty) || String.length text < 3) then
                { model | potentialFoods = [], searchText = text } ! []
            else
                { model | searchText = text } ! [ searchFoods text FoundFoods ]

        ClearAllSelected ->
            { model | selectedFoods = Dict.empty } ! []

        FoundFoods (Err _) ->
            showConnectionError model

        FoundFoods (Ok foods) ->
            { model | potentialFoods = foods } ! []

        SelectFood food ->
            model ! [ getFood food.id GotFood ]

        GotFood (Err _) ->
            showConnectionError model

        GotFood (Ok food) ->
            { model
                | selectedFoods = model.selectedFoods |> Dict.insert food.id food
            }
                ! [ getRecommendedFoods (model.selectedFoods |> Dict.values) FoundRecommendedFoods ]

        FoundRecommendedFoods (Ok foods) ->
            { model | recommendedFoods = foods } ! []

        FoundRecommendedFoods (Err _) ->
            model ! []

        GotNutrients (Err _) ->
            showConnectionError model

        GotNutrients (Ok nutrients) ->
            { model
                | nutrients = nutrients |> List.map (\n -> ( n.id, n )) |> Dict.fromList
            }
                ! []

        UpdateFoodQuantity foodId q ->
            { model
                | selectedFoods =
                    model.selectedFoods
                        |> Dict.update foodId (Maybe.map (\food -> { food | quantity = q }))
            }
                ! []

        UpdateFoodAmount foodId q ->
            { model
                | selectedFoods =
                    model.selectedFoods
                        |> Dict.update foodId (Maybe.map (\food -> { food | amount = q }))
            }
                ! []

        RemoveFood foodId ->
            { model
                | selectedFoods = Dict.remove foodId model.selectedFoods
            }
                ! []

        Hover hoverItem ->
            { model
                | hoverItem = hoverItem
            }
                ! []

        ConnectionModal modal ->
            { model
                | connectionModalState = modal
            }
                ! []



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
