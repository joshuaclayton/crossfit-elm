module View.Loading exposing (view)

import Html exposing (Html, text)
import RemoteData exposing (RemoteData)


view : RemoteData e a -> (a -> Html b) -> Html b
view remoteData f =
    case remoteData of
        RemoteData.Success v ->
            f v

        RemoteData.Failure e ->
            text <| toString e

        RemoteData.Loading ->
            text "Loading"

        RemoteData.NotAsked ->
            text "Loading"
