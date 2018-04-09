module Page.Workouts.Update
    exposing
        ( init
        , subscriptions
        , update
        )

import Page.Workouts.Model as Workouts exposing (Model, Msg(..))
import Page.Workouts.Request as Workouts


init : ( Model, Cmd Msg )
init =
    Workouts.initial ! [ Workouts.makeRequest Workouts.initial ]


subscriptions : Model -> Sub Msg
subscriptions =
    always Sub.none


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
            newModel ! [ Workouts.makeRequest newModel ]

        ClearMovements ->
            let
                newModel =
                    { model | movementFilter = [] }
            in
            newModel ! [ Workouts.makeRequest newModel ]
