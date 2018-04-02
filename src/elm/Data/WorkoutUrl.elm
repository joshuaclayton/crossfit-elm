module Data.WorkoutUrl
    exposing
        ( WorkoutUrl(..)
        , build
        )


type WorkoutUrl
    = NoWorkoutUrl
    | WorkoutUrl String


build : Maybe String -> WorkoutUrl
build value =
    case value of
        Nothing ->
            NoWorkoutUrl

        Just v ->
            WorkoutUrl v
