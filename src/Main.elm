module Main exposing (main)

import Browser
import Html exposing (Html, button, div, h1, p, text)
import Html.Events exposing (onClick)
import Http



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = initialModel
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { counter : Int
    , title : String
    , textData : Data
    , coinData : CoinData
    }


initialModel : () -> ( Model, Cmd Msg )
initialModel _ =
    ( { counter = 0
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
            { url = "https://elm-lang.org/assets/public-opinion.txt"
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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { counter = model.counter + 1
              , title = model.title
              , textData = model.textData
              , coinData = model.coinData
              }
            , Cmd.none
            )

        Decrement ->
            ( { counter = model.counter - 1
              , title = model.title
              , textData = model.textData
              , coinData = model.coinData
              }
            , Cmd.none
            )

        GotTextData result ->
            case result of
                Ok fullText ->
                    ( { counter = model.counter
                      , title = model.title
                      , textData = Success fullText
                      , coinData = model.coinData
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( { counter = model.counter
                      , title = model.title
                      , textData = Failure
                      , coinData = model.coinData
                      }
                    , Cmd.none
                    )

        GotCoinData response ->
            case response of
                Ok fullText ->
                    ( { counter = model.counter
                      , title = model.title
                      , textData = model.textData
                      , coinData = CoinSuccess fullText
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( { counter = model.counter
                      , title = model.title
                      , textData = model.textData
                      , coinData = CoinFailure
                      }
                    , Cmd.none
                    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text model.title ]
        , button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model.counter) ]
        , button [ onClick Increment ] [ text "+" ]
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
