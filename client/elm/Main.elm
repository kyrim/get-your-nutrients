module Main exposing (..)

-- Elm Specific

import Dict exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Helpers exposing (..)
import Navigation
import UrlParser as Url exposing ((</>), s, top, parseHash)


-- API Imports

import Food.Api exposing (..)
import Food.Search exposing (..)


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
import Bootstrap.Popover as Popover
import Bootstrap.ListGroup as ListGroup
import Bootstrap.Form.InputGroup as InputGroup
import Bootstrap.Navbar as Navbar
import Nutrient.View exposing (..)
import Food.View exposing (..)
import Connection.View exposing (..)
import AppCss
import Html.CssHelpers
import BootstrapHelper exposing (rowBuffer)
import FontAwesome.Web as Icon


-- Model


{ id, class, classList } =
    Html.CssHelpers.withNamespace ""


type HoverItem
    = Nutrient Nutrient
    | Food FoodId
    | NothingHovered


type Route
    = Home
    | About


type alias Model =
    { navbarState : Navbar.State
    , nutrients :
        Dict NutrientId Nutrient
        -- Unfortunately, Elm Bootstrap requires state
    , nutrientPopovers : Dict NutrientId Popover.State
    , selectedFoods : LoadState (Dict FoodId Food)
    , searchableFoods : Dict FoodId SearchFood
    , foodSearchResults : LoadState (List SearchFood)
    , hoverItem : HoverItem
    , connectionModalState : ModalState
    , loadingPotentialFoods : Bool
    , history : List (Maybe Route)
    }


type alias Flags =
    { searchableFoods : List SearchFood
    , nutrients : List NutrientFlag
    }


type Msg
    = NavbarMsg Navbar.State
    | UrlChange Navigation.Location
    | NewUrl String
    | ClearSearch
    | UpdateSearchText String
    | ClearAllSelected
    | FoundFoods (List FoodId)
    | SelectFood SearchFood
    | GotFood (Result Http.Error Food)
    | UpdateFoodQuantity FoodId Int
    | UpdateFoodAmount FoodId Int
    | RemoveFood FoodId
    | Hover HoverItem
    | UpdateNutrientPopover NutrientId Popover.State
    | ConnectionModal ModalState


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    let
        ( navbarState, navbarCmd ) =
            Navbar.initialState NavbarMsg
    in
        { navbarState = navbarState
        , nutrients = flags.nutrients |> List.map (\n -> ( n.id, nutrientFlagToNutrient n )) |> Dict.fromList
        , nutrientPopovers = Dict.empty
        , searchableFoods = flags.searchableFoods |> List.map (\n -> ( n.id, n )) |> Dict.fromList
        , selectedFoods = NotLoaded
        , foodSearchResults = NotLoaded
        , hoverItem = NothingHovered
        , connectionModalState = Hide
        , loadingPotentialFoods = True
        , history = [ Url.parsePath route location ]
        }
            ! [ navbarCmd ]



-- Routes


route : Url.Parser (Route -> a) a
route =
    Url.oneOf
        [ Url.map Home top
        , Url.map About (Url.s "about")
        ]



-- View


topBar : Model -> Html Msg
topBar model =
    Navbar.config NavbarMsg
        |> Navbar.withAnimation
        |> Navbar.fixTop
        |> Navbar.brand
            -- Add logo to your brand with a little styling to align nicely
            [ onClick (NewUrl "/"), class [ AppCss.Clickable ] ]
            [ img
                [ src "images/logo.png"
                , style [ ( "width", "30px" ) ]
                ]
                []
            , text "Get Your Nutrients"
            ]
        |> Navbar.items
            [ Navbar.itemLink [ onClick (NewUrl "/about"), class [ AppCss.Clickable ] ] [ text "About" ]
            ]
        |> Navbar.view model.navbarState


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
                    "The purple section on the progress bars below on each nutrient, shows the percentage of nutrients from the food."

        colour =
            case hoverItem of
                NothingHovered ->
                    "#3f9cb8"

                Nutrient nutrient ->
                    nutrient.dailyIntake |> getPercentage nutrient.amount |> getPercentageColour

                Food food ->
                    "#b13fb8"
    in
        Grid.row [ rowBuffer ]
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


searchBar : LoadState (List SearchFood) -> Html Msg
searchBar potentialFoods =
    let
        content =
            case potentialFoods of
                NotLoaded ->
                    []

                Loading previousFoods ->
                    [ ListGroup.anchor [] [ loadingImage ] ]

                Loaded foods ->
                    if List.isEmpty foods then
                        [ ListGroup.anchor [] [ text "No Results" ] ]
                    else
                        List.map
                            (\food ->
                                ListGroup.anchor [ ListGroup.attrs [ onMouseDown (SelectFood food) ] ]
                                    [ text food.name ]
                            )
                            foods
    in
        div []
            [ InputGroup.config
                (InputGroup.text
                    [ Input.placeholder "Search for Food"
                    , Input.attrs
                        [ onInput UpdateSearchText
                        , onBlur ClearSearch
                        , class [ AppCss.SearchInput ]
                        ]
                    ]
                )
                |> InputGroup.large
                |> InputGroup.successors
                    [ InputGroup.span [] [ Icon.search ] ]
                |> InputGroup.attrs [ class [ AppCss.NiceShadow ] ]
                |> InputGroup.view
            , div [ class [ AppCss.SearchResults ] ] [ ListGroup.custom content ]
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


homePage : Model -> List (Grid.Column Msg)
homePage model =
    let
        hoverItemFood =
            getFoodFromHoverItem model.hoverItem

        calculateNutrients nutrients =
            nutrients
                |> calculateNutrientPercentageFromFoods hoverItemFood (emptyDictIfNotLoaded model.selectedFoods)
                |> Dict.values

        constructNutrientSection text nutrientType =
            nutrientSection
                { onHover = UpdateNutrientPopover }
                text
                (hoverItemIsFood model.hoverItem)
                model.nutrientPopovers
                (model.nutrients
                    |> filterNutrient nutrientType
                    |> calculateNutrients
                )
    in
        [ Grid.col [ Col.xs12, Col.sm6 ]
            [ Grid.row [ rowBuffer ]
                [ Grid.col [] [ searchBar model.foodSearchResults ] ]
            , Grid.row [ rowBuffer ]
                [ Grid.col [] [ selectedFoodSection selectedFoodSectionConfig foodRowConfig model.selectedFoods ]
                ]
            ]
        , Grid.col [ Col.xs12, Col.sm6 ]
            [ Grid.row [ rowBuffer ]
                [ Grid.col []
                    [ constructNutrientSection "Vitamins" Vitamin
                    ]
                , Grid.col []
                    [ constructNutrientSection "Minerals" Mineral
                    ]
                ]
            ]
        ]


aboutPage : Model -> List (Grid.Column Msg)
aboutPage model =
    [ Grid.col [ Col.xs12 ]
        [ Card.config []
            |> Card.block []
                [ Card.titleH4 [] [ text "About Get Your Nutrients" ]
                , Card.text []
                    [ text """
                        Get your nutrients is designed to help identify nutrients in certain foods,
                        in an simple, easy and readable way. It has the aim is to provide insight in the lacking
                        or abundance of Vitamins and Minerals in a person's diet and their effects.
                         """
                    ]
                , Card.custom
                    (p []
                        [ span [] [ text " All food and nutrient data has been retrieved and formatted from the " ]
                        , a [ href "https://www.usda.gov/" ] [ text "U.S Department of Argiculture" ]
                        , span [] [ text " food and nutrient database, and all nutrient descriptions sourced and summarised from " ]
                        , a [ href "http://www.webmd.com/vitamins-supplements/" ] [ text "WebMD" ]
                        , span [] [ text "." ]
                        ]
                    )
                , Card.custom
                    (p []
                        [ span [] [ text "If you would like to contact me, please visit my website at: " ]
                        , a [ href "http://www.kyrimsteele.com" ] [ text "www.kyrimsteele.com" ]
                        ]
                    )
                ]
            |> Card.view
        ]
    ]


view : Model -> Html Msg
view model =
    let
        page =
            case List.head model.history of
                Just head ->
                    case head of
                        Just routing ->
                            case routing of
                                Home ->
                                    homePage model

                                About ->
                                    aboutPage model

                        Nothing ->
                            homePage model

                Nothing ->
                    homePage model
    in
        Grid.container []
            -- For bootstrap
            [ topBar model
            , Grid.row [ Row.attrs [ class [ AppCss.Content ] ] ] page
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


getNutrientFoodAmountById : NutrientId -> Food -> Float
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
        UrlChange location ->
            { model
                | history = Url.parsePath route location :: model.history
            }
                ! []

        NewUrl url ->
            ( model
            , Navigation.newUrl url
            )

        NavbarMsg state ->
            { model | navbarState = state } ! []

        ClearSearch ->
            { model | foodSearchResults = NotLoaded } ! []

        UpdateSearchText text ->
            if ((text |> String.trim |> String.isEmpty) || String.length text < 3) then
                { model | foodSearchResults = NotLoaded } ! []
            else
                { model
                    | foodSearchResults = Loading (emptyListIfNotLoaded model.foodSearchResults)
                }
                    ! [ foodSearch text ]

        ClearAllSelected ->
            { model | selectedFoods = NotLoaded } ! []

        FoundFoods foodIds ->
            { model | foodSearchResults = flip Dict.get model.searchableFoods |> flip List.filterMap foodIds |> List.take 10 |> Loaded } ! []

        SelectFood searchFood ->
            { model | selectedFoods = Loading (emptyDictIfNotLoaded model.selectedFoods) } ! [ getFood searchFood.id GotFood ]

        GotFood (Err _) ->
            showConnectionError model

        GotFood (Ok food) ->
            { model
                | selectedFoods =
                    model.selectedFoods
                        |> emptyDictIfNotLoaded
                        |> Dict.insert food.id food
                        |> Loaded
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
                , hoverItem = NothingHovered
            }
                ! []

        Hover hoverItem ->
            { model
                | hoverItem = hoverItem
            }
                ! []

        UpdateNutrientPopover nutrientId popoverState ->
            { model
                | nutrientPopovers =
                    model.nutrientPopovers
                        |> Dict.insert nutrientId popoverState
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
    foodSearchResults FoundFoods



-- Init


main : Program Flags Model Msg
main =
    Navigation.programWithFlags UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
