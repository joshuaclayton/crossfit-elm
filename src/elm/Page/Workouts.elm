module Page.Workouts
    exposing
        ( Model
        , Msg
        , init
        , subscriptions
        , update
        , view
        )

import CrossfitHistory.Enum.MovementType
import CrossfitHistory.Object
import CrossfitHistory.Object.Movement
import CrossfitHistory.Object.Workout
import CrossfitHistory.Query as Query
import Data.WorkoutUrl as WorkoutUrl exposing (WorkoutUrl(..))
import Date exposing (Date)
import Date.Extra.Format as Date
import Date.Extra.Utils as Date
import Graphqelm.Field as Field
import Graphqelm.Http
import Graphqelm.Operation exposing (RootQuery)
import Graphqelm.OptionalArgument exposing (OptionalArgument(Present))
import Graphqelm.SelectionSet exposing (SelectionSet, with)
import Html exposing (..)
import Html.Attributes exposing (classList, href)
import Html.Events exposing (onClick)
import RemoteData exposing (RemoteData)
import View.Loading as Loading


subscriptions : Model -> Sub Msg
subscriptions =
    always Sub.none


initialModel : Model
initialModel =
    { workouts = RemoteData.NotAsked
    , movementFilter = []
    }


type alias Model =
    { workouts : RemoteData Graphqelm.Http.Error Workouts
    , movementFilter : List CrossfitHistory.Enum.MovementType.MovementType
    }


type Msg
    = HandleResponse (RemoteData Graphqelm.Http.Error Workouts)
    | ToggleMovement CrossfitHistory.Enum.MovementType.MovementType
    | ClearMovements


type alias Workout =
    { workoutUrl : WorkoutUrl
    , occurredOn : Date
    , primary : List String
    , secondary : List String
    , primaryMovements : List Movement
    , secondaryMovements : List Movement
    , primaryModifiers : List Movement
    }


type alias Movement =
    { name : String
    , type_ : CrossfitHistory.Enum.MovementType.MovementType
    }



-- type Workouts
--     = Workouts (List Workout) (List Movement) (List Movement)
--


type alias Workouts =
    { workouts : List Workout
    , primaryMovements : List Movement
    , secondaryMovements : List Movement
    }


init : ( Model, Cmd Msg )
init =
    initialModel ! [ makeRequest initialModel ]


view : Model -> Html Msg
view ({ workouts } as model) =
    div []
        [ Loading.view workouts (workoutsView model)
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleResponse r ->
            { model | workouts = r } ! []

        ToggleMovement m ->
            let
                newModel =
                    if List.member m model.movementFilter then
                        { model | movementFilter = List.filter ((/=) m) model.movementFilter }
                    else
                        { model | movementFilter = m :: model.movementFilter }
            in
            newModel ! [ makeRequest newModel ]

        ClearMovements ->
            let
                newModel =
                    { model | movementFilter = [] }
            in
            newModel ! [ makeRequest newModel ]


renderWorkoutUrl : WorkoutUrl -> Html a
renderWorkoutUrl workoutUrl =
    case workoutUrl of
        NoWorkoutUrl ->
            text ""

        WorkoutUrl url ->
            a [ href url ] [ text "View" ]


boldIf : Bool -> Html a -> Html a
boldIf bool v =
    if bool then
        strong [] [ v ]
    else
        v


workoutsView : Model -> Workouts -> Html Msg
workoutsView { movementFilter } { workouts, primaryMovements } =
    div []
        [ p [] [ text <| toString (List.length workouts) ++ " workout(s) found" ]
        , p [ onClick ClearMovements ] [ text "Clear workouts" ]
        , ul []
            (List.map
                (\m ->
                    li [ onClick <| ToggleMovement m.type_ ] [ boldIf (List.member m.type_ movementFilter) <| text m.name ]
                )
                primaryMovements
            )
        , ul []
            (List.map
                (\w ->
                    li [ classList <| List.map ((\v -> ( v, True )) << String.toLower << .name) w.primaryModifiers ]
                        [ h2 [] [ text <| Date.utcIsoDateString w.occurredOn, renderWorkoutUrl w.workoutUrl ]
                        , div []
                            [ h3 [] [ text "Primary Movements" ]
                            , movementList w.primaryMovements
                            , div [] (List.map (\v -> p [] [ text v ]) w.primary)
                            ]
                        , div []
                            [ h3 [] [ text "Secondary Movements" ]
                            , movementList w.secondaryMovements
                            , div [] (List.map (\v -> p [] [ text v ]) w.secondary)
                            ]
                        ]
                )
                workouts
            )
        ]


movementList : List Movement -> Html a
movementList movements =
    ul [] (List.map (\m -> li [] [ text m.name ]) movements)


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


makeRequest : Model -> Cmd Msg
makeRequest model =
    query model
        |> Graphqelm.Http.queryRequest "http://localhost:3000/graphql"
        |> Graphqelm.Http.send (RemoteData.fromResult >> HandleResponse)


movement : SelectionSet Movement CrossfitHistory.Object.Movement
movement =
    CrossfitHistory.Object.Movement.selection Movement
        |> with CrossfitHistory.Object.Movement.name
        |> with CrossfitHistory.Object.Movement.type_


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
