module Page.Workouts.View
    exposing
        ( view
        )

import Data.WorkoutUrl as WorkoutUrl exposing (WorkoutUrl(..))
import Date.Extra.Format as Date
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Page.Workouts.Model as Workouts exposing (Model, Movement, Msg(..), Workout, Workouts)
import View.Loading as Loading


view : Model -> Html Msg
view ({ workouts } as model) =
    div []
        [ Loading.view workouts (workoutsView model)
        ]


workoutsView : Model -> Workouts -> Html Msg
workoutsView { movementFilter } { workouts, primaryMovements } =
    div []
        [ p [] [ text <| toString (List.length workouts) ++ " workout(s) found" ]
        , p [ onClick ClearMovements ] [ text "Clear workouts" ]
        , ul []
            (List.map (\m -> li [] [ toggleCheckbox m ]) primaryMovements)
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


toggleCheckbox : Movement -> Html Msg
toggleCheckbox movement =
    div []
        [ input [ id <| "input-" ++ toString movement.type_, type_ "checkbox", onClick <| ToggleMovement movement.type_ ] []
        , label [ for <| "input-" ++ toString movement.type_ ] [ text movement.name ]
        ]


renderWorkoutUrl : WorkoutUrl -> Html a
renderWorkoutUrl workoutUrl =
    case workoutUrl of
        NoWorkoutUrl ->
            text ""

        WorkoutUrl url ->
            a [ href url ] [ text "View" ]
