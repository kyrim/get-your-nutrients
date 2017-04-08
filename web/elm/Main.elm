module Main exposing (..)

-- Elm Specific

import Dict exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Helpers exposing (..)


-- API Imports

import Nutrient.Api exposing (..)
import Food.Api exposing (..)


-- Model Imports

import Nutrient.Models exposing (..)
import Food.Models exposing (..)
import Connection.Models exposing (..)


-- View imports

import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Card as Card
import Bootstrap.Form.Input as Input
import Nutrient.View exposing (..)
import Food.View exposing (..)
import Navigation.View exposing (..)
import Connection.View exposing (..)
import Html.CssHelpers
import AppCss


-- Model


type HoverItem
    = Nutrient Nutrient
    | Food FoodId
    | NothingHovered


type alias Model =
    { searchText : String
    , nutrients : Dict NutrientId Nutrient
    , selectedFoods : LoadState (Dict FoodId Food)
    , potentialFoods : LoadState (List Food)
    , recommendedFoods : LoadState (List Food)
    , hoverItem : HoverItem
    , connectionModalState : ModalState
    , loadingPotentialFoods : Bool
    }


initialModel : Model
initialModel =
    { searchText = ""
    , nutrients = Dict.empty
    , selectedFoods = NotLoaded
    , potentialFoods = NotLoaded
    , recommendedFoods = NotLoaded
    , hoverItem = NothingHovered
    , connectionModalState = Hide
    , loadingPotentialFoods = True
    }


init : ( Model, Cmd Msg )
init =
    initialModel ! [ getAllNutrients GotNutrients ]



-- View


{ id, class, classList } =
    Html.CssHelpers.withNamespace ""


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
        Grid.row [ Row.attrs [ class [ AppCss.RowBuffer ] ] ]
            [ Grid.col []
                [ Card.config []
                    |> Card.header [ style [ ( "background-color", colour ) ] ]
                        [ text header
                        ]
                    |> Card.block []
                        [ Card.text [] [ text info ] ]
                    |> Card.footer [] [ text sideHeader ]
                    |> Card.view
                ]
            ]


searchBar : String -> LoadState (List Food) -> Html Msg
searchBar searchText potentialFoods =
    let
        content =
            case potentialFoods of
                NotLoaded ->
                    []

                Loading previousFoods ->
                    [ loadingImage ]

                Loaded foods ->
                    if List.isEmpty foods then
                        [ li [] [ text "No Results" ] ]
                    else
                        List.map
                            (\food ->
                                li [ onMouseDown (SelectFood food) ]
                                    [ text food.name ]
                            )
                            foods
    in
        Input.text
            [ Input.large
            , Input.attrs
                [ placeholder "Search for food here and add to calculate nutrients"
                , value searchText
                , onInput UpdateSearchText
                , onBlur ClearSearch
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


recommendedFoodRowConfig : RecommendedFoodRowConfig Msg
recommendedFoodRowConfig =
    { onClick = SelectFood
    }


view : Model -> Html Msg
view model =
    Grid.container []
        -- For bootstrap
        [ CDN.stylesheet
        , topSection
        , Grid.row []
            [ Grid.col []
                [ Grid.row [] [ Grid.col [] [ searchBar model.searchText model.potentialFoods ] ]
                , Grid.row []
                    [ Grid.col [] [ model.selectedFoods |> selectedFoodSection selectedFoodSectionConfig foodRowConfig ]
                    ]
                ]
            , Grid.col []
                [ Grid.row []
                    [ Grid.col []
                        [ Grid.row [] [ Grid.col [] [ informationSection model.hoverItem (emptyDictIfNotLoaded model.selectedFoods) ] ]
                        , Grid.row []
                            [ Grid.col []
                                [ nutrientSection
                                    { mouseOver = Hover << Nutrient, mouseLeave = Hover NothingHovered }
                                    "Vitamins (DI%)"
                                    (hoverItemIsFood model.hoverItem)
                                    (model.nutrients
                                        |> filterNutrient Vitamin
                                        |> calculateNutrientPercentageFromFoods (getFoodFromHoverItem (model.hoverItem)) (emptyDictIfNotLoaded model.selectedFoods)
                                        |> Dict.values
                                    )
                                ]
                            , Grid.col []
                                [ nutrientSection
                                    { mouseOver = Hover << Nutrient, mouseLeave = Hover NothingHovered }
                                    "Minerals (DI%)"
                                    (hoverItemIsFood model.hoverItem)
                                    (model.nutrients
                                        |> filterNutrient Mineral
                                        |> calculateNutrientPercentageFromFoods (getFoodFromHoverItem (model.hoverItem)) (emptyDictIfNotLoaded model.selectedFoods)
                                        |> Dict.values
                                    )
                                ]
                            ]
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
            { model | potentialFoods = NotLoaded } ! []

        UpdateSearchText text ->
            if ((text |> String.trim |> String.isEmpty) || String.length text < 3) then
                { model | potentialFoods = NotLoaded, searchText = text } ! []
            else
                { model | searchText = text, potentialFoods = Loading (emptyListIfNotLoaded model.potentialFoods) } ! [ searchFoods text FoundFoods ]

        ClearAllSelected ->
            { model | selectedFoods = NotLoaded } ! []

        FoundFoods (Err _) ->
            { model | potentialFoods = NotLoaded }
                |> showConnectionError

        FoundFoods (Ok foods) ->
            { model | potentialFoods = (Loaded foods) } ! []

        SelectFood food ->
            { model | selectedFoods = Loading (emptyDictIfNotLoaded model.selectedFoods) } ! [ getFood food.id GotFood ]

        GotFood (Err _) ->
            showConnectionError model

        GotFood (Ok food) ->
            { model
                | selectedFoods =
                    model.selectedFoods
                        |> emptyDictIfNotLoaded
                        |> Dict.insert food.id food
                        |> Loaded
                , recommendedFoods = Loading (emptyListIfNotLoaded model.recommendedFoods)
            }
                ! [ getRecommendedFoods (model.selectedFoods |> emptyDictIfNotLoaded |> Dict.values) FoundRecommendedFoods ]

        FoundRecommendedFoods (Ok foods) ->
            { model | recommendedFoods = Loaded foods } ! []

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
                        |> emptyDictIfNotLoaded
                        |> Dict.update foodId (Maybe.map (\food -> { food | quantity = q }))
                        |> Loaded
            }
                ! []

        UpdateFoodAmount foodId q ->
            { model
                | selectedFoods =
                    model.selectedFoods
                        |> emptyDictIfNotLoaded
                        |> Dict.update foodId (Maybe.map (\food -> { food | amount = q }))
                        |> Loaded
            }
                ! []

        RemoveFood foodId ->
            { model
                | selectedFoods = model.selectedFoods |> emptyDictIfNotLoaded |> Dict.remove foodId |> Loaded
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
