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


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- PORTS


port clearCoinbaseRefreshToken : () -> Cmd msg


port getCoinbaseRefreshToken : (String -> msg) -> Sub msg


port getCoinbaseTemporaryToken : (String -> msg) -> Sub msg



-- MODEL


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel
    , Cmd.batch
        [ Http.get
            { url = "https://api.coinbase.com/v2/exchange-rates?currency=GBP"
            , expect = Http.expectString GotCoinData
            }
        ]
    )


initialModel : Model
initialModel =
    { coinData = CoinLoading
    , tempToken = "nothing"
    , refreshToken = "nothing"
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

        ClearTempToken ->
            ( model
            , clearCoinbaseRefreshToken ()
            )

        ReceiveTempToken code ->
            ( { model | tempToken = code }
            , Cmd.none
            )

        ReceiveRefreshToken code ->
            ( { model | refreshToken = code }
            , Cmd.none
            )



--         ReceiveRefreshToken code ->
-- ( { model | tempToken = code }
-- , Cmd.none
-- )
-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ getCoinbaseTemporaryToken ReceiveTempToken
        , getCoinbaseRefreshToken ReceiveRefreshToken
        ]



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
