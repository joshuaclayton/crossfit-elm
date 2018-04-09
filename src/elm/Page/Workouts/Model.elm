module Page.Workouts.Model
    exposing
        ( Model
        , Movement
        , Msg(..)
        , Workout
        , Workouts
        , initial
        )

import CrossfitHistory.Enum.MovementType
import Data.WorkoutUrl as WorkoutUrl exposing (WorkoutUrl(..))
import Date exposing (Date)
import Graphqelm.Http
import RemoteData exposing (RemoteData)


type Msg
    = HandleResponse (RemoteData Graphqelm.Http.Error Workouts)
    | ToggleMovement CrossfitHistory.Enum.MovementType.MovementType
    | ClearMovements


type alias Model =
    { workouts : RemoteData Graphqelm.Http.Error Workouts
    , movementFilter : List CrossfitHistory.Enum.MovementType.MovementType
    }


type alias Workout =
    { workoutUrl : WorkoutUrl
    , occurredOn : Date
    , primary : List String
    , secondary : List String
    , primaryMovements : List Movement
    , secondaryMovements : List Movement
    , primaryModifiers : List Movement
    }


type alias Workouts =
    { workouts : List Workout
    , primaryMovements : List Movement
    , secondaryMovements : List Movement
    }


type alias Movement =
    { name : String
    , type_ : CrossfitHistory.Enum.MovementType.MovementType
    }


initial : Model
initial =
    { workouts = RemoteData.NotAsked
    , movementFilter = []
    }
