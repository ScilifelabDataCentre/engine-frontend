module Wizard.View exposing (view)

import Browser exposing (Document)
import Html exposing (..)
import Shared.Locale exposing (l)
import Wizard.Common.AppState exposing (AppState)
import Wizard.Common.View.Layout as Layout
import Wizard.Common.View.Page as Page
import Wizard.Dashboard.View
import Wizard.KMEditor.View
import Wizard.KnowledgeModels.View
import Wizard.Models exposing (Model)
import Wizard.Msgs exposing (Msg(..))
import Wizard.Organization.View
import Wizard.Public.View
import Wizard.Questionnaires.View
import Wizard.Routes as Routes
import Wizard.Users.View


l_ : String -> AppState -> String
l_ =
    l "Wizard.View"


view : Model -> Document Msg
view model =
    if not model.appState.valid then
        Layout.misconfigured model.appState

    else
        case model.appState.route of
            Routes.DashboardRoute ->
                Wizard.Dashboard.View.view model.appState model.dashboardModel
                    |> Layout.app model

            Routes.QuestionnairesRoute route ->
                model.questionnairesModel
                    |> Wizard.Questionnaires.View.view route model.appState
                    |> Html.map QuestionnairesMsg
                    |> Layout.app model

            Routes.KMEditorRoute route ->
                model.kmEditorModel
                    |> Wizard.KMEditor.View.view route model.appState
                    |> Html.map KMEditorMsg
                    |> Layout.app model

            Routes.KnowledgeModelsRoute route ->
                model.kmPackagesModel
                    |> Wizard.KnowledgeModels.View.view route model.appState
                    |> Html.map KnowledgeModelsMsg
                    |> Layout.app model

            Routes.OrganizationRoute ->
                model.organizationModel
                    |> Wizard.Organization.View.view model.appState
                    |> Html.map OrganizationMsg
                    |> Layout.app model

            Routes.PublicRoute route ->
                model.publicModel
                    |> Wizard.Public.View.view route model.appState
                    |> Html.map PublicMsg
                    |> Layout.public model

            Routes.UsersRoute route ->
                model.users
                    |> Wizard.Users.View.view route model.appState
                    |> Html.map UsersMsg
                    |> Layout.app model

            Routes.NotAllowedRoute ->
                notAllowedView model.appState
                    |> Layout.app model

            Routes.NotFoundRoute ->
                if model.appState.session.user == Nothing then
                    Layout.public model <| notFoundView model.appState

                else
                    Layout.app model <| notFoundView model.appState


notFoundView : AppState -> Html msg
notFoundView appState =
    Page.illustratedMessage
        { image = "page_not_found"
        , heading = l_ "notFound.title" appState
        , lines = [ l_ "notFound.message" appState ]
        }


notAllowedView : AppState -> Html msg
notAllowedView appState =
    Page.illustratedMessage
        { image = "security"
        , heading = l_ "notAllowed.title" appState
        , lines = [ l_ "notAllowed.message" appState ]
        }
