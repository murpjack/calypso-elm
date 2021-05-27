port module Main exposing (main)

import Browser
import Coinbase.Endpoints exposing (..)
import Env exposing (clientId)
import Html exposing (Html, a, button, div, h1, input, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as D
import Main.LoginView exposing (clientUri)
import Main.Types exposing (..)



-- MAIN


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- PORTS


port sendCounter : String -> Cmd msg


port receiveCounter : (String -> msg) -> Sub msg



-- MODEL


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initialModel flags
    , Cmd.batch
        [ Http.get
            { url = "https://elm-lang.org/assets/public-opinion.txt"
            , expect = Http.expectString GotCoinData
            }
        ]
    )


initialModel : Flags -> Model
initialModel flags =
    { flags = flags
    , counter = 0
    , counting = "0"
    , title = "Title"
    , coinData = CoinLoading
    }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model
                | counter = model.counter + 1
              }
            , Cmd.none
            )

        Decrement ->
            ( { model
                | counter = model.counter - 1
              }
            , Cmd.none
            )

        GotCoinData response ->
            case response of
                Ok fullText ->
                    ( { model
                        | coinData = CoinSuccess fullText
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( { model
                        | coinData = CoinFailure
                      }
                    , Cmd.none
                    )

        InputChanged counting ->
            ( { model | counting = counting }
            , sendCounter counting
            )

        Sent ->
            ( { model | counting = "" }
            , sendCounter model.counting
            )

        Received counting ->
            ( { model | counting = counting }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    receiveCounter Received



-- VIEW


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
