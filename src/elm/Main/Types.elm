module Main.Types exposing (..)

import Http


type Msg
    = GotCoinData (Result Http.Error String)
    | ClearTempToken
    | ReceiveTempToken String
    | ReceiveRefreshToken String


type alias Model =
    { coinData : CoinData
    , tempToken : String
    , refreshToken : String
    }


type CoinData
    = CoinFailure
    | CoinLoading
    | CoinSuccess String
