module Main.View exposing (..)

import Env exposing (clientId)
import Html exposing (Html, a, button, div, h1, input, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, onInput)
import Json.Decode as D
import Main.LoginView exposing (clientUri)
import Main.Types exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text model.title ]
        , button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model.counter) ]
        , div [] [ text ("Yay " ++ model.counting) ]
        , button [ onClick Increment ] [ text "+" ]
        , a [ href (clientUri clientId), target "_blank" ] [ text ("Sign in " ++ clientId) ]
        , input
            [ type_ "number"
            , onInput InputChanged
            , placeholder model.counting
            , on "keydown" (ifIsEnter Sent)
            , value model.counting
            ]
            []
        , p [] [ text (showCBData model.coinData) ]
        , p [] [ text (showData model.textData) ]
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


showData : Data -> String
showData status =
    case status of
        Loading ->
            "Loading..."

        Failure ->
            "Failure."

        Success fullText ->
            fullText


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
