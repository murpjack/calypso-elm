module Endpoints exposing (..)


connect : String
connect =
    "https://www.coinbase.com/oauth/authorize"


newToken : String
newToken =
    "https://api.coinbase.com/oauth/token"


revokeToken : String
revokeToken =
    "https://api.coinbase.com/oauth/revoke"
