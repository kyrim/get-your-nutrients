module Main exposing (..)

import Debug exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Api exposing (..)
import Http exposing (..)
import Models exposing (..)
import BlazeHelpers exposing (..)


-- Model


type HoverItem
    = Nutrient Nutrient
    | Food Food
    | NothingHovered


type Modal
    = Hide
    | Show


type alias Model =
    { nutrients : List Nutrient
    , selectedFoods : List Food
    , potentialFoods : List Food
    , recommendedFoods : List Food
    , hoverItem : HoverItem
    , connectionModalState : Modal
    }


initialModel : Model
initialModel =
    { nutrients = []
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


getNutrientPercentage : Nutrient -> Int
getNutrientPercentage nutrient =
    (nutrient.amount / nutrient.dailyIntake * 100 |> round)


getPercentageColour : Int -> String
getPercentageColour percentage =
    if percentage <= 20 then
        "#FF3D7F"
    else if percentage <= 50 then
        "#FFAB2E"
    else if percentage <= 80 then
        "#7FC7AF"
    else
        "#6ABE6E"


nutrientProgress : Nutrient -> Html Msg
nutrientProgress nutrient =
    let
        label =
            nutrient.name

        percentage =
            getNutrientPercentage nutrient

        percentageStr =
            toString percentage

        colour =
            getPercentageColour percentage
    in
        div
            [ class "o-grid__cell o-grid__cell--width-100 nutrient-progress"
            , onMouseOver (Hover (Nutrient nutrient))
            , onMouseLeave (Hover NothingHovered)
            ]
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


nutrientSection : List Nutrient -> String -> Html Msg
nutrientSection nutrients category =
    gridWithCls "large-fit"
        ([ fullCell [ heading2 category ]
         ]
            ++ (List.map
                    nutrientProgress
                    nutrients
               )
        )


foodAmount : Food -> Html Msg
foodAmount food =
    div []
        []


foodRow : Food -> Html Msg
foodRow food =
    div
        [ class "c-card__item c-field c-field--choice food-item"
        , onMouseOver (Hover (Food food))
        , onMouseLeave (Hover NothingHovered)
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
                    , onInput
                        (\val ->
                            UpdateFoodQuantity food
                                (String.toInt val |> Result.toMaybe |> Maybe.withDefault 1)
                        )
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
                    , onInput (\val -> UpdateFoodAmount food (String.toInt val |> Result.toMaybe |> Maybe.withDefault 100))
                    ]
                    []
                , span
                    [ class "marker" ]
                    [ text "g" ]
                , a
                    [ class "selected-food-button" ]
                    [ i [ class "fa fa-times", onClick (RemoveFood food) ] []
                    ]
                ]
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
                    "Please hover over a food or nutrient to view a summary of that particular item."

                Nutrient nutrient ->
                    nutrient.description

                Food food ->
                    "The purple section on the progress bars below on each nutrient, shows the perentage of nutrients from the food."

        colour =
            case hoverItem of
                NothingHovered ->
                    "#3f9cb8"

                Nutrient nutrient ->
                    nutrient |> getNutrientPercentage |> getPercentageColour

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


connectionError : Html Msg
connectionError =
    div []
        [ div [ class "c-overlay" ]
            []
        , div [ class "o-modal connection-error" ]
            [ div [ class "c-card" ]
                [ Html.header [ class "c-card__header" ]
                    [ button [ class "c-button c-button--close", type_ "button", onClick (ConnectionModal Hide) ]
                        [ text "×" ]
                    , h2 [ class "c-heading" ]
                        [ text "Oh no!" ]
                    ]
                , div [ class "c-card__body" ]
                    [ text "There was a connection error. Please ensure you are connected to the internet and try again." ]
                , footer [ class "c-card__footer" ]
                    [ button [ class "c-button c-button--brand", type_ "button", onClick (ConnectionModal Hide) ]
                        [ text "Close" ]
                    ]
                ]
            ]
        ]


view : Model -> Html Msg
view model =
    let
        connectionModal =
            case model.connectionModalState of
                Hide ->
                    div [] []

                Show ->
                    connectionError
    in
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
                        [ fullCell [ informationSection model.hoverItem ]
                        , cell 50 [ nutrientSection (filterNutrient model.nutrients Vitamin |> calculateNutrientPercentageFromFoods model.selectedFoods) "Vitamins (DI%)" ]
                        , cell 50 [ nutrientSection (filterNutrient model.nutrients Mineral |> calculateNutrientPercentageFromFoods model.selectedFoods) "Minerals (DI%)" ]
                        ]
                    ]
                ]
            , connectionModal
            ]


calculateNutrientPercentageFromFoods : List Food -> List Nutrient -> List Nutrient
calculateNutrientPercentageFromFoods foods nutrients =
    List.map
        (\nutrient ->
            { nutrient
                | amount = (foods |> List.map (\food -> getNutrientFoodAmountById nutrient.id food) |> List.sum)
            }
        )
        nutrients


getNutrientFoodAmountById : Int -> Food -> Float
getNutrientFoodAmountById id food =
    List.filter (\fn -> fn.nutrientId == id) food.nutrients
        |> List.map (\fn -> fn.amount * toFloat food.amount * toFloat food.quantity)
        |> List.sum
        |> log "nutrientAmountByID"


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
    | UpdateFoodAmount Food Int
    | RemoveFood Food
    | Hover HoverItem
    | ConnectionModal Modal



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

        ClearAllSelected ->
            { model | selectedFoods = [] } ! []

        SearchForFood food ->
            if ((food |> String.trim |> String.isEmpty) || String.length food < 3) then
                { model | potentialFoods = [] } ! []
            else
                model ! [ searchFoods food FoundFoods ]

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
