-- Do not manually edit this file, it was auto-generated by Graphqelm
-- https://github.com/dillonkearns/graphqelm


module CrossfitHistory.Query exposing (..)

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
import Graphqelm.Operation exposing (RootQuery)
import Graphqelm.OptionalArgument exposing (OptionalArgument(Absent))
import Graphqelm.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode exposing (Decoder)


{-| Select fields to build up a top-level query. The request can be sent with
functions from `Graphqelm.Http`.
-}
selection : (a -> constructor) -> SelectionSet (a -> constructor) RootQuery
selection constructor =
    Object.selection constructor


type alias PrimaryMovementsOptionalArguments =
    { matching : OptionalArgument (List (Maybe CrossfitHistory.Enum.MovementType.MovementType)) }


primary_movements : (PrimaryMovementsOptionalArguments -> PrimaryMovementsOptionalArguments) -> SelectionSet decodesTo CrossfitHistory.Object.Movement -> Field (List decodesTo) RootQuery
primary_movements fillInOptionals object =
    let
        filledInOptionals =
            fillInOptionals { matching = Absent }

        optionalArgs =
            [ Argument.optional "matching" filledInOptionals.matching (Encode.enum CrossfitHistory.Enum.MovementType.toString |> Encode.maybe |> Encode.list) ]
                |> List.filterMap identity
    in
    Object.selectionField "primary_movements" optionalArgs object (identity >> Decode.list)


type alias SecondaryMovementsOptionalArguments =
    { matching : OptionalArgument (List (Maybe CrossfitHistory.Enum.MovementType.MovementType)) }


secondary_movements : (SecondaryMovementsOptionalArguments -> SecondaryMovementsOptionalArguments) -> SelectionSet decodesTo CrossfitHistory.Object.Movement -> Field (List decodesTo) RootQuery
secondary_movements fillInOptionals object =
    let
        filledInOptionals =
            fillInOptionals { matching = Absent }

        optionalArgs =
            [ Argument.optional "matching" filledInOptionals.matching (Encode.enum CrossfitHistory.Enum.MovementType.toString |> Encode.maybe |> Encode.list) ]
                |> List.filterMap identity
    in
    Object.selectionField "secondary_movements" optionalArgs object (identity >> Decode.list)


type alias WorkoutsOptionalArguments =
    { movement : OptionalArgument CrossfitHistory.Enum.MovementType.MovementType, movements : OptionalArgument (List (Maybe CrossfitHistory.Enum.MovementType.MovementType)), all_movements : OptionalArgument (List (Maybe CrossfitHistory.Enum.MovementType.MovementType)), aerobic : OptionalArgument Bool, participated : OptionalArgument Bool }


workouts : (WorkoutsOptionalArguments -> WorkoutsOptionalArguments) -> SelectionSet decodesTo CrossfitHistory.Object.Workout -> Field (List decodesTo) RootQuery
workouts fillInOptionals object =
    let
        filledInOptionals =
            fillInOptionals { movement = Absent, movements = Absent, all_movements = Absent, aerobic = Absent, participated = Absent }

        optionalArgs =
            [ Argument.optional "movement" filledInOptionals.movement (Encode.enum CrossfitHistory.Enum.MovementType.toString), Argument.optional "movements" filledInOptionals.movements (Encode.enum CrossfitHistory.Enum.MovementType.toString |> Encode.maybe |> Encode.list), Argument.optional "all_movements" filledInOptionals.all_movements (Encode.enum CrossfitHistory.Enum.MovementType.toString |> Encode.maybe |> Encode.list), Argument.optional "aerobic" filledInOptionals.aerobic Encode.bool, Argument.optional "participated" filledInOptionals.participated Encode.bool ]
                |> List.filterMap identity
    in
    Object.selectionField "workouts" optionalArgs object (identity >> Decode.list)
