module Connection.View exposing (..)

import Connection.Models exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias ConnectionErrorConfig msg =
    { onClose : msg
    }


connectionError : ConnectionErrorConfig msg -> ModalState -> Html msg
connectionError config state =
    let
        modalView =
            case state of
                Hide ->
                    div [] []

                Show ->
                    div []
                        [ div [ class "c-overlay" ]
                            []
                        , div [ class "o-modal connection-error" ]
                            [ div [ class "c-card" ]
                                [ Html.header [ class "c-card__header" ]
                                    [ button [ class "c-button c-button--close", type_ "button", onClick config.onClose ]
                                        [ text "×" ]
                                    , h2 [ class "c-heading" ]
                                        [ text "Oh no!" ]
                                    ]
                                , div [ class "c-card__body" ]
                                    [ text "There was a connection error. Please ensure you are connected to the internet and try again." ]
                                , footer [ class "c-card__footer" ]
                                    [ button [ class "c-button c-button--brand", type_ "button", onClick config.onClose ]
                                        [ text "Close" ]
                                    ]
                                ]
                            ]
                        ]
    in
        modalView