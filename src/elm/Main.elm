port module Main exposing (main)

import Browser
import Endpoints exposing (..)
import Html exposing (Html, button, div, h1, input, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as D



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = initialModel
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- PORTS


port sendCounter : String -> Cmd msg


port receiveCounter : (String -> msg) -> Sub msg



-- MODEL


type alias Model =
    { counter : Int
    , counting : String
    , title : String
    , textData : Data
    , coinData : CoinData
    }


clientUri : String
clientUri =
    "https://www.coinbase.com/oauth/authorize?client_id=ee13f194f5631432e54213d20da4d929ebc7dc8a2b0d644af69a1eb08081a0f0&redirect_uri=https%3A%2F%2Fmurphyme.co.uk%2Fcalypso%2Fsuccess&response_type=code&scope=wallet%3Auser%3Aread"


initialModel : () -> ( Model, Cmd Msg )
initialModel _ =
    ( { counter = 0
      , counting = "0"
      , title = "Title"
      , textData = Loading
      , coinData = CoinLoading
      }
    , Cmd.batch
        [ Http.get
            { url = "https://elm-lang.org/assets/public-opinion.txt"
            , expect = Http.expectString GotTextData
            }
        , Http.get
            { url = clientUri
            , expect = Http.expectString GotCoinData
            }
        ]
    )


type Data
    = Failure
    | Loading
    | Success String


type CoinData
    = CoinFailure
    | CoinLoading
    | CoinSuccess String



-- UPDATE


type Msg
    = Increment
    | Decrement
    | GotTextData (Result Http.Error String)
    | GotCoinData (Result Http.Error String)
    | InputChanged String
    | Sent
    | Received String


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

        GotTextData result ->
            case result of
                Ok fullText ->
                    ( { model
                        | textData = Success fullText
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( { model
                        | textData = Failure
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
