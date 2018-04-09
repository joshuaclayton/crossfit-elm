module Page.Workouts.Request
    exposing
        ( makeRequest
        )

import CrossfitHistory.Object
import CrossfitHistory.Object.Movement
import CrossfitHistory.Object.Workout
import CrossfitHistory.Query as Query
import Data.WorkoutUrl as WorkoutUrl exposing (WorkoutUrl(..))
import Date.Extra.Utils as Date
import Graphqelm.Field as Field
import Graphqelm.Http
import Graphqelm.Operation exposing (RootQuery)
import Graphqelm.OptionalArgument exposing (OptionalArgument(Present))
import Graphqelm.SelectionSet exposing (SelectionSet, with)
import Page.Workouts.Model as Workouts exposing (Model, Movement, Msg(..), Workout, Workouts)
import RemoteData


makeRequest : Model -> Cmd Msg
makeRequest model =
    query model
        |> Graphqelm.Http.queryRequest "http://localhost:3000/graphql"
        |> Graphqelm.Http.send (RemoteData.fromResult >> HandleResponse)


query : Model -> SelectionSet Workouts RootQuery
query model =
    let
        applyFilter optionalArgs =
            case model.movementFilter of
                [] ->
                    optionalArgs

                filters ->
                    { optionalArgs | all_movements = Present <| List.map Just filters }
    in
    Query.selection Workouts
        |> with (Query.workouts applyFilter workout)
        |> with (Query.primary_movements identity movement)
        |> with (Query.secondary_movements identity movement)


maybeStringToLines : Maybe String -> List String
maybeStringToLines =
    Maybe.map String.lines
        >> Maybe.withDefault []


workout : SelectionSet Workout CrossfitHistory.Object.Workout
workout =
    CrossfitHistory.Object.Workout.selection Workout
        |> with (Field.map WorkoutUrl.build CrossfitHistory.Object.Workout.workout_url)
        |> with (Field.map Date.unsafeFromString CrossfitHistory.Object.Workout.occurred_on)
        |> with (Field.map String.lines CrossfitHistory.Object.Workout.primary)
        |> with (Field.map maybeStringToLines CrossfitHistory.Object.Workout.secondary)
        |> with (CrossfitHistory.Object.Workout.primary_movements movement)
        |> with (CrossfitHistory.Object.Workout.secondary_movements movement)
        |> with (CrossfitHistory.Object.Workout.primary_modifiers movement)


movement : SelectionSet Movement CrossfitHistory.Object.Movement
movement =
    CrossfitHistory.Object.Movement.selection Movement
        |> with CrossfitHistory.Object.Movement.name
        |> with CrossfitHistory.Object.Movement.type_
