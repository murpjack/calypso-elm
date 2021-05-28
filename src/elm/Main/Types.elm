module Main.Types exposing (..)

import Http


type Msg
    = Increment
    | Decrement
    | GotCoinData (Result Http.Error String)
    | InputChanged String
    | Sent
    | Received String


type alias Model =
    { flags : Flags
    , counter : Int
    , counting : String
    , coinData : CoinData
    }


type alias Flags =
    { clientId1 : String
    }


type CoinData
    = CoinFailure
    | CoinLoading
    | CoinSuccess String
