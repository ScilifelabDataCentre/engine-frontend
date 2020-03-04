module Wizard.Documents.Create.Msgs exposing (..)

import Form
import Shared.Error.ApiError exposing (ApiError)
import Wizard.Documents.Common.Document exposing (Document)
import Wizard.Questionnaires.Common.Questionnaire exposing (Questionnaire)
import Wizard.Questionnaires.Common.Template exposing (Template)


type Msg
    = GetQuestionnairesCompleted (Result ApiError (List Questionnaire))
    | GetTemplatesCompleted (Result ApiError (List Template))
    | FormMsg Form.Msg
    | PostDocumentCompleted (Result ApiError Document)