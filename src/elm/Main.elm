module Main exposing (..)

import CrossfitHistory.Object
import CrossfitHistory.Object.Workout
import CrossfitHistory.Query as Query
import Date exposing (Date)
import Date.Extra.Format as Date
import Date.Extra.Utils as Date
import Graphqelm.Field as Field
import Graphqelm.Http
import Graphqelm.Operation exposing (RootQuery)
import Graphqelm.OptionalArgument exposing (OptionalArgument(Absent))
import Graphqelm.SelectionSet exposing (SelectionSet, with)
import Html exposing (..)
import Html.Attributes exposing (href)
import RemoteData exposing (RemoteData)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , subscriptions = always Sub.none
        , view = view
        , update = update
        }


type WorkoutUrl
    = NoWorkoutUrl
    | WorkoutUrl String


toWorkoutUrl : Maybe String -> WorkoutUrl
toWorkoutUrl value =
    case value of
        Nothing ->
            NoWorkoutUrl

        Just v ->
            WorkoutUrl v


type alias Model =
    { workouts : RemoteData Graphqelm.Http.Error Workouts
    }


model : Model
model =
    { workouts = RemoteData.NotAsked }


init : ( Model, Cmd Msg )
init =
    model ! [ makeRequest ]



-- UPDATE


type Workouts
    = Workouts (List Workout)


query : SelectionSet Workouts RootQuery
query =
    let
        defaults =
            always
                { movement = Absent, movements = Absent, all_movements = Absent, aerobic = Absent, participated = Absent }
    in
    Query.selection Workouts
        |> with (Query.workouts defaults workout)


makeRequest : Cmd Msg
makeRequest =
    query
        |> Graphqelm.Http.queryRequest "http://localhost:3000/graphql"
        |> Graphqelm.Http.send (RemoteData.fromResult >> HandleResponse)


type alias Workout =
    { workoutUrl : WorkoutUrl
    , occurredOn : Date
    }


workout : SelectionSet Workout CrossfitHistory.Object.Workout
workout =
    CrossfitHistory.Object.Workout.selection Workout
        |> with (Field.map toWorkoutUrl CrossfitHistory.Object.Workout.workout_url)
        |> with (Field.map Date.unsafeFromString CrossfitHistory.Object.Workout.occurred_on)


type Msg
    = HandleResponse (RemoteData Graphqelm.Http.Error Workouts)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleResponse r ->
            { model | workouts = r } ! []


view : Model -> Html Msg
view { workouts } =
    div []
        [ loading workouts workoutsView
        ]


loading : RemoteData e a -> (a -> Html b) -> Html b
loading remoteData f =
    case remoteData of
        RemoteData.Success v ->
            f v

        RemoteData.Failure e ->
            text <| toString e

        RemoteData.Loading ->
            text "Loading"

        RemoteData.NotAsked ->
            text "Loading"


renderWorkoutUrl : WorkoutUrl -> Html a
renderWorkoutUrl workoutUrl =
    case workoutUrl of
        NoWorkoutUrl ->
            text ""

        WorkoutUrl url ->
            a [ href url ] [ text "View" ]


workoutsView : Workouts -> Html a
workoutsView (Workouts workouts) =
    table []
        (List.map
            (\w ->
                tr []
                    [ td [] [ renderWorkoutUrl w.workoutUrl ]
                    , td [] [ text <| Date.utcIsoDateString w.occurredOn ]
                    ]
            )
            workouts
        )
