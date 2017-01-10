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
    { nutrients : List Nutrient
    , selectedFoods : List Food
    , potentialFoods : List Food
    , recommendedFoods : List Food
    }


initialModel : Model
initialModel =
    { nutrients = []
    , selectedFoods = []
    , potentialFoods = []
    , recommendedFoods = []
    }


init : ( Model, Cmd Msg )
init =
    initialModel ! [ getAllNutrients GotNutrients ]



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
    nutrientProgress nutrient.name (nutrient.amount / nutrient.dailyIntake * 100 |> round)


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
            [ input
                [ type_ "number"
                , Html.Attributes.min "1"
                , value (food.quantity |> toString)
                , onInput (\val -> UpdateFoodQuantity food (String.toInt val |> Result.toMaybe |> Maybe.withDefault 1))
                ]
                []
            , text food.name
            ]
        ]


emptyList : String -> Html Msg
emptyList message =
    div [ class "c-card list-empty" ]
        [ div [ class "c-card-item list-empty-text" ]
            [ text message
            ]
        ]


selectedFoodSection : List Food -> Html Msg
selectedFoodSection foods =
    let
        displaySelectedFoodMenu =
            (List.length foods) > 0

        selectedFoodMenu =
            div [ class "c-card c-card--menu" ]
                (List.map
                    foodRow
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
                        , onClick ClearAllSelected
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
                [ selectedFoodDisplay
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


informationSection : String -> String -> Html Msg
informationSection heading info =
    grid
        [ fullCell
            [ div
                [ class "c-card info-panel" ]
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
                    , onInput SearchForFood
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


view : Model -> Html Msg
view model =
    div []
        [ topSection
        , grid
            [ cell 50
                [ defaultCellWithCls "u-letter-box--small" [ searchBar model.potentialFoods ]
                , grid
                    [ cell 60 [ selectedFoodSection model.selectedFoods ]
                    , cell 40 [ recommendedFoodSection model.recommendedFoods ]
                    ]
                ]
            , defaultCell
                [ grid
                    [ fullCell [ informationSection "Nothing Selected" "Please add food to begin calculating." ]
                    , cell 50 [ nutrientSection (filterNutrient model.nutrients Vitamin) "Vitamins (DI%)" ]
                    , cell 50 [ nutrientSection (filterNutrient model.nutrients Mineral) "Minerals (DI%)" ]
                    ]
                ]
            ]
        ]


filterNutrient : List Nutrient -> NutrientType -> List Nutrient
filterNutrient nutrients nutrientType =
    List.filter (\nutrient -> nutrient.nutrientType == nutrientType) nutrients



-- MESSAGES


type Msg
    = ClearSearch
    | ClearAllSelected
    | SearchForFood String
    | FoundFoods (Result Http.Error (List Food))
    | SelectFood Food
    | GotFood (Result Http.Error Food)
    | FoundRecommendedFoods (Result Http.Error (List Food))
    | GotNutrients (Result Http.Error (List Nutrient))
    | UpdateFoodQuantity Food Int



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


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ClearSearch ->
            { model | potentialFoods = [] } ! []

        ClearAllSelected ->
            { model | selectedFoods = [] } ! []

        SearchForFood food ->
            if ((food |> String.trim |> String.isEmpty) || String.length food < 3) then
                { model | potentialFoods = [] } ! []
            else
                model ! [ searchFoods food FoundFoods ]

        FoundFoods (Err _) ->
            model ! []

        FoundFoods (Ok foods) ->
            { model | potentialFoods = foods } ! []

        SelectFood food ->
            model ! [ getFood food.id GotFood ]

        GotFood (Err _) ->
            model ! []

        GotFood (Ok food) ->
            { model
                | selectedFoods = model.selectedFoods ++ [ food ]
            }
                ! [ getRecommendedFoods model.selectedFoods FoundRecommendedFoods ]

        FoundRecommendedFoods (Ok foods) ->
            { model | potentialFoods = foods } ! []

        FoundRecommendedFoods (Err _) ->
            model ! []

        GotNutrients (Err _) ->
            model ! []

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
