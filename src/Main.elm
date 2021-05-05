module Main exposing (main)

import Browser
import Html exposing (Html, button, div, h2, span, text)
import Html.Events exposing (onClick)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    Int


init : Model
init =
    1234



-- UPDATE


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div
            []
            [ div [] [ h2 [] [ text "Watchlist" ] ]
            , div [] [ h2 [] [ text "Portfolio" ] ]
            , div [] [ text ("$" ++ String.fromInt model) ]
            ]
        , button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model) ]
        , button [ onClick Increment ] [ text "+" ]
        , div
            []
            [ div [] [ span [] [ text "B" ], span [] [ text "Title" ] ]
            , div [] [ span [] [ text "B" ], span [] [ text "Title" ] ]
            , div [] [ span [] [ text "B" ], span [] [ text "Title" ] ]
            ]
        ]
