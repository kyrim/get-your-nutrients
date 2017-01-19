module Main exposing (..)

-- Elm Specific

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
    | Food Food
    | NothingHovered


type alias Model =
    { nutrients : List Nutrient
    , searchText : String
    , selectedFoods : List Food
    , potentialFoods : List Food
    , recommendedFoods : List Food
    , hoverItem : HoverItem
    , connectionModalState : ModalState
    }


initialModel : Model
initialModel =
    { searchText = ""
    , nutrients = []
    , selectedFoods = []
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


informationSection : HoverItem -> Html Msg
informationSection hoverItem =
    let
        header =
            case hoverItem of
                NothingHovered ->
                    "Summary"

                Nutrient nutrient ->
                    nutrient.name

                Food food ->
                    food.name

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
                        [ text header ]
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


getFoodFromHoverItem : HoverItem -> Maybe Food
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
    | UpdateFoodQuantity Food Int
    | UpdateFoodAmount Food Int
    | RemoveFood Food
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
                    [ cell 60 [ selectedFoodSection selectedFoodSectionConfig foodRowConfig model.selectedFoods ]
                    , cell 40 [ recommendedFoodSection model.recommendedFoods ]
                    ]
                ]
            , defaultCell
                [ grid
                    [ fullCell [ informationSection model.hoverItem ]
                    , cell 50
                        [ nutrientSection
                            { mouseOver = (\n -> (Hover (Nutrient n))), mouseLeave = Hover NothingHovered }
                            (hoverItemIsFood
                                model.hoverItem
                            )
                            "Vitamins (DI%)"
                            (filterNutrient model.nutrients Vitamin
                                |> calculateNutrientPercentageFromFoods (getFoodFromHoverItem (model.hoverItem)) model.selectedFoods
                            )
                        ]
                    , cell 50
                        [ nutrientSection
                            { mouseOver = (\n -> (Hover (Nutrient n))), mouseLeave = Hover NothingHovered }
                            (hoverItemIsFood
                                model.hoverItem
                            )
                            "Minerals (DI%)"
                            (filterNutrient model.nutrients Mineral
                                |> calculateNutrientPercentageFromFoods (getFoodFromHoverItem (model.hoverItem)) model.selectedFoods
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


calculateNutrientPercentageFromFoods : Maybe Food -> List Food -> List Nutrient -> List Nutrient
calculateNutrientPercentageFromFoods hoveredFood foods nutrients =
    List.map
        (\nutrient ->
            { nutrient
                | amount = (foods |> List.map (\food -> getNutrientFoodAmountById nutrient.id food) |> List.sum)
                , hoveredAmount =
                    case hoveredFood of
                        Nothing ->
                            0

                        Just food ->
                            getNutrientFoodAmountById nutrient.id food
            }
        )
        nutrients


getNutrientFoodAmountById : Int -> Food -> Float
getNutrientFoodAmountById id food =
    List.filter (\fn -> fn.nutrientId == id) food.nutrients
        |> List.map (\fn -> fn.amount * toFloat food.amount * toFloat food.quantity)
        |> List.sum


filterNutrient : List Nutrient -> NutrientType -> List Nutrient
filterNutrient nutrients nutrientType =
    List.filter (\nutrient -> nutrient.nutrientType == nutrientType) nutrients



-- Update


updateFood : List Food -> Int -> (Food -> Food) -> List Food
updateFood list id updateFunction =
    let
        updater food =
            if food.id == id then
                updateFunction food
            else
                food
    in
        List.map updater list


removeFood : List Food -> Int -> List Food
removeFood list id =
    let
        filter food =
            food.id /= id
    in
        List.filter filter list


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
            { model | selectedFoods = [] } ! []

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
                | selectedFoods = model.selectedFoods ++ [ food ]
            }
                ! [ getRecommendedFoods model.selectedFoods FoundRecommendedFoods ]

        FoundRecommendedFoods (Ok foods) ->
            { model | recommendedFoods = foods } ! []

        FoundRecommendedFoods (Err _) ->
            model ! []

        GotNutrients (Err _) ->
            showConnectionError model

        GotNutrients (Ok nutrients) ->
            { model
                | nutrients = model.nutrients ++ nutrients
            }
                ! []

        UpdateFoodQuantity food q ->
            { model
                | selectedFoods = (updateFood model.selectedFoods food.id (\n -> { n | quantity = q }))
            }
                ! []

        UpdateFoodAmount food q ->
            { model
                | selectedFoods = (updateFood model.selectedFoods food.id (\n -> { n | amount = q }))
            }
                ! []

        RemoveFood food ->
            { model
                | selectedFoods = removeFood model.selectedFoods food.id
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
