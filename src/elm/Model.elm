module Model
    exposing
        ( Model
        , Msg(..)
        )

import Page.Workouts.Model as Workouts


type alias Model =
    { workouts : Workouts.Model
    }


type Msg
    = HandleWorkoutsMsg Workouts.Msg
