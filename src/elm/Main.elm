module Main exposing (..)

import Html exposing (Html)
import Model exposing (Model, Msg)
import Update
import View


main : Program Never Model Msg
main =
    Html.program
        { init = Update.init
        , subscriptions = Update.subscriptions
        , view = View.view
        , update = Update.update
        }
