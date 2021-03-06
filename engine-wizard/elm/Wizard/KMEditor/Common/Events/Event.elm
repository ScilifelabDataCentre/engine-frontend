module Wizard.KMEditor.Common.Events.Event exposing
    ( Event(..)
    , decoder
    , encode
    , getEntityUuid
    , getEntityVisibleName
    , getUuid
    , isAddAnswer
    , isAddChapter
    , isAddExpert
    , isAddQuestion
    , isAddReference
    , isAddTag
    , isDeleteAnswer
    , isDeleteChapter
    , isDeleteExpert
    , isDeleteQuestion
    , isDeleteReference
    , isDeleteTag
    , isEditAnswer
    , isEditChapter
    , isEditExpert
    , isEditQuestion
    , isEditReference
    , isEditTag
    )

import Json.Decode as D exposing (Decoder)
import Json.Encode as E
import Wizard.KMEditor.Common.Events.AddAnswerEventData as AddAnswerEventData exposing (AddAnswerEventData)
import Wizard.KMEditor.Common.Events.AddChapterEventData as AddChapterEventData exposing (AddChapterEventData)
import Wizard.KMEditor.Common.Events.AddExpertEventData as AddExpertEventData exposing (AddExpertEventData)
import Wizard.KMEditor.Common.Events.AddIntegrationEventData as AddIntegrationEventData exposing (AddIntegrationEventData)
import Wizard.KMEditor.Common.Events.AddKnowledgeModelEventData as AddKnowledgeModelEventData exposing (AddKnowledgeModelEventData)
import Wizard.KMEditor.Common.Events.AddQuestionEventData as AddQuestionEventData exposing (AddQuestionEventData)
import Wizard.KMEditor.Common.Events.AddReferenceEventData as AddReferenceEventData exposing (AddReferenceEventData)
import Wizard.KMEditor.Common.Events.AddTagEventData as AddTagEventData exposing (AddTagEventData)
import Wizard.KMEditor.Common.Events.CommonEventData as CommonEventData exposing (CommonEventData)
import Wizard.KMEditor.Common.Events.EditAnswerEventData as EditAnswerEventData exposing (EditAnswerEventData)
import Wizard.KMEditor.Common.Events.EditChapterEventData as EditChapterEventData exposing (EditChapterEventData)
import Wizard.KMEditor.Common.Events.EditExpertEventData as EditExpertEventData exposing (EditExpertEventData)
import Wizard.KMEditor.Common.Events.EditIntegrationEventData as EditIntegrationEventData exposing (EditIntegrationEventData)
import Wizard.KMEditor.Common.Events.EditKnowledgeModelEventData as EditKnowledgeModelEventData exposing (EditKnowledgeModelEventData)
import Wizard.KMEditor.Common.Events.EditQuestionEventData as EditQuestionEventData exposing (EditQuestionEventData)
import Wizard.KMEditor.Common.Events.EditReferenceEventData as EditReferenceEventData exposing (EditReferenceEventData)
import Wizard.KMEditor.Common.Events.EditTagEventData as EditTagEventData exposing (EditTagEventData)
import Wizard.KMEditor.Common.Events.EventField as EventField
import Wizard.KMEditor.Common.Events.MoveEventData as MoveEventData exposing (MoveEventData)
import Wizard.KMEditor.Common.KnowledgeModel.Answer exposing (Answer)
import Wizard.KMEditor.Common.KnowledgeModel.Chapter exposing (Chapter)
import Wizard.KMEditor.Common.KnowledgeModel.Expert exposing (Expert)
import Wizard.KMEditor.Common.KnowledgeModel.KnowledgeModel exposing (KnowledgeModel)
import Wizard.KMEditor.Common.KnowledgeModel.Question as Question exposing (Question)
import Wizard.KMEditor.Common.KnowledgeModel.Reference as Reference exposing (Reference)
import Wizard.KMEditor.Common.KnowledgeModel.Tag exposing (Tag)


type Event
    = AddKnowledgeModelEvent AddKnowledgeModelEventData CommonEventData
    | EditKnowledgeModelEvent EditKnowledgeModelEventData CommonEventData
    | AddChapterEvent AddChapterEventData CommonEventData
    | EditChapterEvent EditChapterEventData CommonEventData
    | DeleteChapterEvent CommonEventData
    | AddTagEvent AddTagEventData CommonEventData
    | EditTagEvent EditTagEventData CommonEventData
    | DeleteTagEvent CommonEventData
    | AddIntegrationEvent AddIntegrationEventData CommonEventData
    | EditIntegrationEvent EditIntegrationEventData CommonEventData
    | DeleteIntegrationEvent CommonEventData
    | AddQuestionEvent AddQuestionEventData CommonEventData
    | EditQuestionEvent EditQuestionEventData CommonEventData
    | DeleteQuestionEvent CommonEventData
    | AddAnswerEvent AddAnswerEventData CommonEventData
    | EditAnswerEvent EditAnswerEventData CommonEventData
    | DeleteAnswerEvent CommonEventData
    | AddReferenceEvent AddReferenceEventData CommonEventData
    | EditReferenceEvent EditReferenceEventData CommonEventData
    | DeleteReferenceEvent CommonEventData
    | AddExpertEvent AddExpertEventData CommonEventData
    | EditExpertEvent EditExpertEventData CommonEventData
    | DeleteExpertEvent CommonEventData
    | MoveQuestionEvent MoveEventData CommonEventData
    | MoveAnswerEvent MoveEventData CommonEventData
    | MoveReferenceEvent MoveEventData CommonEventData
    | MoveExpertEvent MoveEventData CommonEventData


decoder : Decoder Event
decoder =
    D.field "eventType" D.string
        |> D.andThen decoderByType


decoderByType : String -> Decoder Event
decoderByType eventType =
    case eventType of
        "AddKnowledgeModelEvent" ->
            D.map2 AddKnowledgeModelEvent AddKnowledgeModelEventData.decoder CommonEventData.decoder

        "EditKnowledgeModelEvent" ->
            D.map2 EditKnowledgeModelEvent EditKnowledgeModelEventData.decoder CommonEventData.decoder

        "AddChapterEvent" ->
            D.map2 AddChapterEvent AddChapterEventData.decoder CommonEventData.decoder

        "EditChapterEvent" ->
            D.map2 EditChapterEvent EditChapterEventData.decoder CommonEventData.decoder

        "DeleteChapterEvent" ->
            D.map DeleteChapterEvent CommonEventData.decoder

        "AddTagEvent" ->
            D.map2 AddTagEvent AddTagEventData.decoder CommonEventData.decoder

        "EditTagEvent" ->
            D.map2 EditTagEvent EditTagEventData.decoder CommonEventData.decoder

        "DeleteTagEvent" ->
            D.map DeleteTagEvent CommonEventData.decoder

        "AddIntegrationEvent" ->
            D.map2 AddIntegrationEvent AddIntegrationEventData.decoder CommonEventData.decoder

        "EditIntegrationEvent" ->
            D.map2 EditIntegrationEvent EditIntegrationEventData.decoder CommonEventData.decoder

        "DeleteIntegrationEvent" ->
            D.map DeleteIntegrationEvent CommonEventData.decoder

        "AddQuestionEvent" ->
            D.map2 AddQuestionEvent AddQuestionEventData.decoder CommonEventData.decoder

        "EditQuestionEvent" ->
            D.map2 EditQuestionEvent EditQuestionEventData.decoder CommonEventData.decoder

        "DeleteQuestionEvent" ->
            D.map DeleteQuestionEvent CommonEventData.decoder

        "AddAnswerEvent" ->
            D.map2 AddAnswerEvent AddAnswerEventData.decoder CommonEventData.decoder

        "EditAnswerEvent" ->
            D.map2 EditAnswerEvent EditAnswerEventData.decoder CommonEventData.decoder

        "DeleteAnswerEvent" ->
            D.map DeleteAnswerEvent CommonEventData.decoder

        "AddReferenceEvent" ->
            D.map2 AddReferenceEvent AddReferenceEventData.decoder CommonEventData.decoder

        "EditReferenceEvent" ->
            D.map2 EditReferenceEvent EditReferenceEventData.decoder CommonEventData.decoder

        "DeleteReferenceEvent" ->
            D.map DeleteReferenceEvent CommonEventData.decoder

        "AddExpertEvent" ->
            D.map2 AddExpertEvent AddExpertEventData.decoder CommonEventData.decoder

        "EditExpertEvent" ->
            D.map2 EditExpertEvent EditExpertEventData.decoder CommonEventData.decoder

        "DeleteExpertEvent" ->
            D.map DeleteExpertEvent CommonEventData.decoder

        "MoveQuestionEvent" ->
            D.map2 MoveQuestionEvent MoveEventData.decoder CommonEventData.decoder

        "MoveAnswerEvent" ->
            D.map2 MoveAnswerEvent MoveEventData.decoder CommonEventData.decoder

        "MoveReferenceEvent" ->
            D.map2 MoveReferenceEvent MoveEventData.decoder CommonEventData.decoder

        "MoveExpertEvent" ->
            D.map2 MoveExpertEvent MoveEventData.decoder CommonEventData.decoder

        _ ->
            D.fail <| "Unknown event type: " ++ eventType


encode : Event -> E.Value
encode event =
    let
        ( encodedCommonData, encodedEventData ) =
            case event of
                AddKnowledgeModelEvent eventData commonData ->
                    ( AddKnowledgeModelEventData.encode eventData, CommonEventData.encode commonData )

                EditKnowledgeModelEvent eventData commonData ->
                    ( EditKnowledgeModelEventData.encode eventData, CommonEventData.encode commonData )

                AddChapterEvent eventData commonData ->
                    ( AddChapterEventData.encode eventData, CommonEventData.encode commonData )

                EditChapterEvent eventData commonData ->
                    ( EditChapterEventData.encode eventData, CommonEventData.encode commonData )

                DeleteChapterEvent commonData ->
                    ( [ ( "eventType", E.string "DeleteChapterEvent" ) ], CommonEventData.encode commonData )

                AddTagEvent eventData commonData ->
                    ( AddTagEventData.encode eventData, CommonEventData.encode commonData )

                EditTagEvent eventData commonData ->
                    ( EditTagEventData.encode eventData, CommonEventData.encode commonData )

                DeleteTagEvent commonData ->
                    ( [ ( "eventType", E.string "DeleteTagEvent" ) ], CommonEventData.encode commonData )

                AddIntegrationEvent eventData commonData ->
                    ( AddIntegrationEventData.encode eventData, CommonEventData.encode commonData )

                EditIntegrationEvent eventData commonData ->
                    ( EditIntegrationEventData.encode eventData, CommonEventData.encode commonData )

                DeleteIntegrationEvent commonData ->
                    ( [ ( "eventType", E.string "DeleteIntegrationEvent" ) ], CommonEventData.encode commonData )

                AddQuestionEvent eventData commonData ->
                    ( AddQuestionEventData.encode eventData, CommonEventData.encode commonData )

                EditQuestionEvent eventData commonData ->
                    ( EditQuestionEventData.encode eventData, CommonEventData.encode commonData )

                DeleteQuestionEvent commonData ->
                    ( [ ( "eventType", E.string "DeleteQuestionEvent" ) ], CommonEventData.encode commonData )

                AddAnswerEvent eventData commonData ->
                    ( AddAnswerEventData.encode eventData, CommonEventData.encode commonData )

                EditAnswerEvent eventData commonData ->
                    ( EditAnswerEventData.encode eventData, CommonEventData.encode commonData )

                DeleteAnswerEvent commonData ->
                    ( [ ( "eventType", E.string "DeleteAnswerEvent" ) ], CommonEventData.encode commonData )

                AddReferenceEvent eventData commonData ->
                    ( AddReferenceEventData.encode eventData, CommonEventData.encode commonData )

                EditReferenceEvent eventData commonData ->
                    ( EditReferenceEventData.encode eventData, CommonEventData.encode commonData )

                DeleteReferenceEvent commonData ->
                    ( [ ( "eventType", E.string "DeleteReferenceEvent" ) ], CommonEventData.encode commonData )

                AddExpertEvent eventData commonData ->
                    ( AddExpertEventData.encode eventData, CommonEventData.encode commonData )

                EditExpertEvent eventData commonData ->
                    ( EditExpertEventData.encode eventData, CommonEventData.encode commonData )

                DeleteExpertEvent commonData ->
                    ( [ ( "eventType", E.string "DeleteExpertEvent" ) ], CommonEventData.encode commonData )

                MoveQuestionEvent eventData commonData ->
                    ( MoveEventData.encode "MoveQuestionEvent" eventData, CommonEventData.encode commonData )

                MoveAnswerEvent eventData commonData ->
                    ( MoveEventData.encode "MoveAnswerEvent" eventData, CommonEventData.encode commonData )

                MoveReferenceEvent eventData commonData ->
                    ( MoveEventData.encode "MoveReferenceEvent" eventData, CommonEventData.encode commonData )

                MoveExpertEvent eventData commonData ->
                    ( MoveEventData.encode "MoveExpertEvent" eventData, CommonEventData.encode commonData )
    in
    E.object <| encodedCommonData ++ encodedEventData


getUuid : Event -> String
getUuid =
    getCommonData >> .uuid


getEntityUuid : Event -> String
getEntityUuid =
    getCommonData >> .entityUuid


getCommonData : Event -> CommonEventData
getCommonData event =
    case event of
        AddKnowledgeModelEvent _ commonData ->
            commonData

        EditKnowledgeModelEvent _ commonData ->
            commonData

        AddChapterEvent _ commonData ->
            commonData

        EditChapterEvent _ commonData ->
            commonData

        DeleteChapterEvent commonData ->
            commonData

        AddTagEvent _ commonData ->
            commonData

        EditTagEvent _ commonData ->
            commonData

        DeleteTagEvent commonData ->
            commonData

        AddIntegrationEvent _ commonData ->
            commonData

        EditIntegrationEvent _ commonData ->
            commonData

        DeleteIntegrationEvent commonData ->
            commonData

        AddQuestionEvent _ commonData ->
            commonData

        EditQuestionEvent _ commonData ->
            commonData

        DeleteQuestionEvent commonData ->
            commonData

        AddAnswerEvent _ commonData ->
            commonData

        EditAnswerEvent _ commonData ->
            commonData

        DeleteAnswerEvent commonData ->
            commonData

        AddReferenceEvent _ commonData ->
            commonData

        EditReferenceEvent _ commonData ->
            commonData

        DeleteReferenceEvent commonData ->
            commonData

        AddExpertEvent _ commonData ->
            commonData

        EditExpertEvent _ commonData ->
            commonData

        DeleteExpertEvent commonData ->
            commonData

        MoveQuestionEvent _ commonData ->
            commonData

        MoveAnswerEvent _ commonData ->
            commonData

        MoveReferenceEvent _ commonData ->
            commonData

        MoveExpertEvent _ commonData ->
            commonData


getEntityVisibleName : Event -> Maybe String
getEntityVisibleName event =
    case event of
        AddKnowledgeModelEvent eventData _ ->
            Just eventData.name

        EditKnowledgeModelEvent eventData _ ->
            EventField.getValue eventData.name

        AddTagEvent eventData _ ->
            Just eventData.name

        EditTagEvent eventData _ ->
            EventField.getValue eventData.name

        AddIntegrationEvent eventData _ ->
            Just eventData.name

        EditIntegrationEvent eventData _ ->
            EventField.getValue eventData.name

        AddChapterEvent eventData _ ->
            Just eventData.title

        EditChapterEvent eventData _ ->
            EventField.getValue eventData.title

        AddQuestionEvent eventData _ ->
            AddQuestionEventData.getEntityVisibleName eventData

        EditQuestionEvent eventData _ ->
            EditQuestionEventData.getEntityVisibleName eventData

        AddAnswerEvent eventData _ ->
            Just eventData.label

        EditAnswerEvent eventData _ ->
            EventField.getValue eventData.label

        AddReferenceEvent eventData _ ->
            AddReferenceEventData.getEntityVisibleName eventData

        EditReferenceEvent eventData _ ->
            EditReferenceEventData.getEntityVisibleName eventData

        AddExpertEvent eventData _ ->
            Just eventData.name

        EditExpertEvent eventData _ ->
            EventField.getValue eventData.name

        _ ->
            Nothing



-- Test event types


isAddChapter : KnowledgeModel -> Event -> Bool
isAddChapter km event =
    case event of
        AddChapterEvent _ commonData ->
            commonData.parentUuid == km.uuid

        _ ->
            False


isAddTag : KnowledgeModel -> Event -> Bool
isAddTag km event =
    case event of
        AddTagEvent _ commonData ->
            commonData.parentUuid == km.uuid

        _ ->
            False


isAddQuestion : String -> Event -> Bool
isAddQuestion parentUuid event =
    case event of
        AddQuestionEvent _ commonData ->
            commonData.parentUuid == parentUuid

        _ ->
            False


isAddAnswer : Question -> Event -> Bool
isAddAnswer question event =
    case event of
        AddAnswerEvent _ commonData ->
            commonData.parentUuid == Question.getUuid question

        _ ->
            False


isAddExpert : Question -> Event -> Bool
isAddExpert question event =
    case event of
        AddExpertEvent _ commonData ->
            commonData.parentUuid == Question.getUuid question

        _ ->
            False


isAddReference : Question -> Event -> Bool
isAddReference question event =
    case event of
        AddReferenceEvent _ commonData ->
            commonData.parentUuid == Question.getUuid question

        _ ->
            False


isEditChapter : Chapter -> Event -> Bool
isEditChapter chapter event =
    case event of
        EditChapterEvent _ commonData ->
            commonData.entityUuid == chapter.uuid

        _ ->
            False


isEditTag : Tag -> Event -> Bool
isEditTag tag event =
    case event of
        EditTagEvent _ commonData ->
            commonData.entityUuid == tag.uuid

        _ ->
            False


isEditQuestion : Question -> Event -> Bool
isEditQuestion question event =
    case event of
        EditQuestionEvent _ commonData ->
            commonData.entityUuid == Question.getUuid question

        _ ->
            False


isEditAnswer : Answer -> Event -> Bool
isEditAnswer answer event =
    case event of
        EditAnswerEvent _ commonData ->
            commonData.entityUuid == answer.uuid

        _ ->
            False


isEditReference : Reference -> Event -> Bool
isEditReference reference event =
    case event of
        EditReferenceEvent _ commonData ->
            commonData.entityUuid == Reference.getUuid reference

        _ ->
            False


isEditExpert : Expert -> Event -> Bool
isEditExpert expert event =
    case event of
        EditExpertEvent _ commonData ->
            commonData.entityUuid == expert.uuid

        _ ->
            False


isDeleteChapter : Chapter -> Event -> Bool
isDeleteChapter chapter event =
    case event of
        DeleteChapterEvent commonData ->
            commonData.entityUuid == chapter.uuid

        _ ->
            False


isDeleteTag : Tag -> Event -> Bool
isDeleteTag tag event =
    case event of
        DeleteTagEvent commonData ->
            commonData.entityUuid == tag.uuid

        _ ->
            False


isDeleteQuestion : Question -> Event -> Bool
isDeleteQuestion question event =
    case event of
        DeleteQuestionEvent commonData ->
            commonData.entityUuid == Question.getUuid question

        _ ->
            False


isDeleteAnswer : Answer -> Event -> Bool
isDeleteAnswer answer event =
    case event of
        DeleteAnswerEvent commonData ->
            commonData.entityUuid == answer.uuid

        _ ->
            False


isDeleteReference : Reference -> Event -> Bool
isDeleteReference reference event =
    case event of
        DeleteReferenceEvent commonData ->
            commonData.entityUuid == Reference.getUuid reference

        _ ->
            False


isDeleteExpert : Expert -> Event -> Bool
isDeleteExpert expert event =
    case event of
        DeleteExpertEvent commonData ->
            commonData.entityUuid == expert.uuid

        _ ->
            False
