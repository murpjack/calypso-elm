module Main.LoginView exposing (..)

import Env exposing (clientId)
import Html exposing (Html, a, div, h1, p, text)
import Html.Attributes exposing (..)
import Main.Types exposing (Msg)
import Url.Builder exposing (crossOrigin, string)


loginView : () -> Html Msg
loginView _ =
    div []
        [ h1 [] [ text "Calypso" ]
        , div []
            [ a [ href (clientUri clientId), target "_blank" ] [ text "Sign in with Coinbase" ]
            ]
        , div []
            [ p [] [ text "Calypso" ]
            , p [] [ text "Calypso" ]
            , p []
                [ text "</> by Jack Murphy in "
                , a [ href "https://elm-lang.org/", target "_blank" ]
                    [ text "Elm"
                    ]
                , text "."
                ]
            ]
        ]


clientUri : String -> String
clientUri clientId =
    crossOrigin "https://www.coinbase.com"
        [ "oauth", "authorize" ]
        [ string "client_id"
            clientId
        , string "response_type"
            "code"
        , string "redirect_uri"
            "https://murphyme.co.uk/calypso/success"
        ]
