module Questionnaires.Requests exposing (..)

import Auth.Models exposing (Session)
import Http
import Questionnaires.Common.Models exposing (Questionnaire, questionnaireListDecoder)
import Requests


getQuestionnaires : Session -> Http.Request (List Questionnaire)
getQuestionnaires session =
    Requests.get session "/questionnaires" questionnaireListDecoder


deleteQuestionnaire : String -> Session -> Http.Request String
deleteQuestionnaire uuid session =
    Requests.delete session ("/questionnaires/" ++ uuid)
