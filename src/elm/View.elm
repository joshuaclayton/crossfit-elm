module View
    exposing
        ( view
        )

import Html exposing (..)
import Model exposing (Model, Msg(..))
import Page.Workouts.View as Workouts


view : Model -> Html Msg
view { workouts } =
    Html.map HandleWorkoutsMsg <| Workouts.view workouts
