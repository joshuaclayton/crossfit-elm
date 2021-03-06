-- Do not manually edit this file, it was auto-generated by Graphqelm
-- https://github.com/dillonkearns/graphqelm


module CrossfitHistory.Object.Movement exposing (..)

import CrossfitHistory.Enum.MovementType
import CrossfitHistory.InputObject
import CrossfitHistory.Interface
import CrossfitHistory.Object
import CrossfitHistory.Scalar
import CrossfitHistory.Union
import Graphqelm.Field as Field exposing (Field)
import Graphqelm.Internal.Builder.Argument as Argument exposing (Argument)
import Graphqelm.Internal.Builder.Object as Object
import Graphqelm.Internal.Encode as Encode exposing (Value)
import Graphqelm.OptionalArgument exposing (OptionalArgument(Absent))
import Graphqelm.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode


{-| Select fields to build up a SelectionSet for this object.
-}
selection : (a -> constructor) -> SelectionSet (a -> constructor) CrossfitHistory.Object.Movement
selection constructor =
    Object.selection constructor


id : Field CrossfitHistory.Scalar.Id CrossfitHistory.Object.Movement
id =
    Object.fieldDecoder "id" [] (Decode.oneOf [ Decode.string, Decode.float |> Decode.map toString, Decode.int |> Decode.map toString, Decode.bool |> Decode.map toString ] |> Decode.map CrossfitHistory.Scalar.Id)


name : Field String CrossfitHistory.Object.Movement
name =
    Object.fieldDecoder "name" [] Decode.string


type_ : Field CrossfitHistory.Enum.MovementType.MovementType CrossfitHistory.Object.Movement
type_ =
    Object.fieldDecoder "type" [] CrossfitHistory.Enum.MovementType.decoder


workouts : SelectionSet decodesTo CrossfitHistory.Object.Workout -> Field (List decodesTo) CrossfitHistory.Object.Movement
workouts object =
    Object.selectionField "workouts" [] object (identity >> Decode.list)
