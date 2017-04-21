module Connection.View exposing (..)

import Connection.Models exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias ConnectionErrorConfig msg =
    { onClose : msg
    }


loadingImage : Html msg
loadingImage =
    li []
        [ div [ class "spinner" ]
            [ div [ class "rect1" ]
                []
            , div [ class "rect2" ]
                []
            , div [ class "rect3" ]
                []
            , div [ class "rect4" ]
                []
            , div [ class "rect5" ]
                []
            ]
        ]


connectionError : ConnectionErrorConfig msg -> ModalState -> Html msg
connectionError config state =
    let
        modalView =
            case state of
                Hide ->
                    div [] []

                Show ->
                    div []
                        [ div []
                            []
                        , div [ class "connection-error" ]
                            [ div []
                                [ Html.header []
                                    [ button [ type_ "button", onClick config.onClose ]
                                        [ text "×" ]
                                    , h2 []
                                        [ text "Oh no!" ]
                                    ]
                                , div []
                                    [ text "There was a connection error. Please ensure you are connected to the internet and try again." ]
                                , footer []
                                    [ button [ type_ "button", onClick config.onClose ]
                                        [ text "Close" ]
                                    ]
                                ]
                            ]
                        ]
    in
        modalView
