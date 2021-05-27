port module Main.State exposing (..)

import Http
import Main.Types exposing (CoinData(..), Data(..), Flags, Model, Msg(..))



-- MODEL


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initialModel flags
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


initialModel : Flags -> Model
initialModel flags =
    { flags = flags
    , counter = 0
    , counting = "0"
    , title = "Title"
    , textData = Loading
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



-- PORTS


port sendCounter : String -> Cmd msg


port receiveCounter : (String -> msg) -> Sub msg
