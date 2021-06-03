module Main.Types exposing (..)

import Http


type Msg
    = GotCoinData (Result Http.Error String)
    | Sent
    | Received String


type alias Model =
    { flags : Flags
    , coinData : CoinData
    }


type alias Flags =
    { clientId1 : String
    }


type CoinData
    = CoinFailure
    | CoinLoading
    | CoinSuccess String
