port module Main exposing (main)

-- import Json.Decode as D

import Browser
import Coinbase.Endpoints exposing (..)
import Html exposing (Html, div, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Main.Types exposing (..)
import Main.View exposing (cryptoView, loginView)



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
    , coinData = CoinLoading
    }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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

        Sent ->
            ( model
            , sendCounter "1"
            )

        Received counting ->
            ( model
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
        [ loginView model
        , cryptoView model
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



-- ifIsEnter : Msg -> D.Decoder Msg
-- ifIsEnter msg =
--     D.field "key" D.string
--         |> D.andThen
--             (\key ->
--                 if key == "Enter" then
--                     D.succeed msg
--                 else
--                     D.fail "some other key"
--             )
