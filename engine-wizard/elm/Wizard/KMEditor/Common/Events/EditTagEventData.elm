module Wizard.KMEditor.Common.Events.EditTagEventData exposing
    ( EditTagEventData
    , decoder
    , encode
    )

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as D
import Json.Encode as E
import Json.Encode.Extra as E
import Wizard.KMEditor.Common.Events.EventField as EventField exposing (EventField)


type alias EditTagEventData =
    { name : EventField String
    , description : EventField (Maybe String)
    , color : EventField String
    }


decoder : Decoder EditTagEventData
decoder =
    D.succeed EditTagEventData
        |> D.required "name" (EventField.decoder D.string)
        |> D.required "description" (EventField.decoder (D.nullable D.string))
        |> D.required "color" (EventField.decoder D.string)


encode : EditTagEventData -> List ( String, E.Value )
encode data =
    [ ( "eventType", E.string "EditTagEvent" )
    , ( "name", EventField.encode E.string data.name )
    , ( "description", EventField.encode (E.maybe E.string) data.description )
    , ( "color", EventField.encode E.string data.color )
    ]
