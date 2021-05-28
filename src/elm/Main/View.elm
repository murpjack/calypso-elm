module Main.View exposing (..)

import Env exposing (clientId)
import Html exposing (Html, a, div, h1, p, text)
import Html.Attributes exposing (..)
import Json.Decode as D
import Main.Types exposing (..)
import Url.Builder exposing (crossOrigin, string)


loginView : Model -> Html Msg
loginView model =
    div []
        [ h1 [] [ text "Calypso" ]
        , div []
            [ a [ href (clientUri clientId), target "_blank" ] [ text "Sign in with Coinbase" ]
            ]
        , div []
            [ p [] [ text "Calypso" ]
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


cryptoView : Model -> Html Msg
cryptoView model =
    div []
        [ h1 [] [ text "Calypso" ]
        , div []
            [ div [] []
            , div [] []
            , div [] []
            ]
        , div []
            [ p [] [ text "Calypso" ]
            , p []
                [ text "</> by Jack Murphy in "
                , a [ href "https://elm-lang.org/", target "_blank" ]
                    [ text "Elm"
                    ]
                , text "."
                ]
            ]
        ]


showCBData : CoinData -> String
showCBData status =
    case status of
        CoinLoading ->
            "Loading..."

        CoinFailure ->
            "Failure."

        CoinSuccess fullText ->
            fullText


ifIsEnter : Msg -> D.Decoder Msg
ifIsEnter msg =
    D.field "key" D.string
        |> D.andThen
            (\key ->
                if key == "Enter" then
                    D.succeed msg

                else
                    D.fail "some other key"
            )
