module KnowledgeModels.Create.Models exposing (..)

import Common.Form exposing (CustomFormError)
import Common.Types exposing (ActionResult(..))
import Form exposing (Form)
import KnowledgeModels.Models exposing (KnowledgeModelCreateForm, initKnowledgeModelCreateForm)
import PackageManagement.Models exposing (PackageDetail)


type alias Model =
    { packages : ActionResult (List PackageDetail)
    , savingKnowledgeModel : ActionResult String
    , form : Form CustomFormError KnowledgeModelCreateForm
    , newUuid : Maybe String
    }


initialModel : Model
initialModel =
    { packages = Loading
    , savingKnowledgeModel = Unset
    , form = initKnowledgeModelCreateForm
    , newUuid = Nothing
    }
