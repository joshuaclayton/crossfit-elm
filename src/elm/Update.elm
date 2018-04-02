module Update
    exposing
        ( init
        , subscriptions
        , update
        )

import Model exposing (Model, Msg(..))
import Page.Workouts as Workouts


subscriptions : Model -> Sub Msg
subscriptions { workouts } =
    Sub.map HandleWorkoutsMsg <|
        Workouts.subscriptions workouts


init : ( Model, Cmd Msg )
init =
    let
        ( workoutsModel, workoutsCmd ) =
            Workouts.init
    in
    { workouts = workoutsModel }
        ! [ Cmd.map HandleWorkoutsMsg workoutsCmd ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleWorkoutsMsg msg ->
            let
                ( workoutsModel, workoutsMsg ) =
                    Workouts.update msg model.workouts
            in
            { model | workouts = workoutsModel }
                ! [ Cmd.map HandleWorkoutsMsg workoutsMsg ]
