module Model
    exposing
        ( Model
        , Msg(..)
        )

import Page.Workouts as Workouts


type alias Model =
    { workouts : Workouts.Model
    }


type Msg
    = HandleWorkoutsMsg Workouts.Msg
