module Wizard.KnowledgeModels.Detail.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Markdown
import Shared.Locale exposing (l, lg, lh, lx)
import Version
import Wizard.Auth.Permission as Perm exposing (hasPerm)
import Wizard.Common.Api.Packages as PackagesApi
import Wizard.Common.AppState exposing (AppState)
import Wizard.Common.Config exposing (Registry(..))
import Wizard.Common.Html exposing (emptyNode, faSet, linkTo)
import Wizard.Common.View.ItemIcon as ItemIcon
import Wizard.Common.View.Modal as Modal
import Wizard.Common.View.Page as Page
import Wizard.KMEditor.Routes exposing (Route(..))
import Wizard.KnowledgeModels.Common.OrganizationInfo exposing (OrganizationInfo)
import Wizard.KnowledgeModels.Common.PackageDetail exposing (PackageDetail)
import Wizard.KnowledgeModels.Common.PackageState as PackageState
import Wizard.KnowledgeModels.Detail.Models exposing (..)
import Wizard.KnowledgeModels.Detail.Msgs exposing (..)
import Wizard.KnowledgeModels.Routes exposing (Route(..))
import Wizard.Questionnaires.Routes
import Wizard.Routes as Routes
import Wizard.Utils exposing (listFilterJust, listInsertIf)


l_ : String -> AppState -> String
l_ =
    l "Wizard.KnowledgeModels.Detail.View"


lh_ : String -> List (Html msg) -> AppState -> List (Html msg)
lh_ =
    lh "Wizard.KnowledgeModels.Detail.View"


lx_ : String -> AppState -> Html msg
lx_ =
    lx "Wizard.KnowledgeModels.Detail.View"


view : AppState -> Model -> Html Msg
view appState model =
    Page.actionResultView appState (viewPackage appState model) model.package


viewPackage : AppState -> Model -> PackageDetail -> Html Msg
viewPackage appState model package =
    div [ class "KnowledgeModels__Detail" ]
        [ header appState package
        , readme appState package
        , sidePanel appState package
        , deleteVersionModal appState model package
        ]


header : AppState -> PackageDetail -> Html Msg
header appState package =
    let
        exportAction =
            a [ class "link-with-icon", href <| PackagesApi.exportPackageUrl package.id appState, target "_blank" ]
                [ faSet "kmDetail.export" appState
                , lx_ "header.export" appState
                ]

        forkAction =
            linkTo appState
                (Routes.KMEditorRoute <| CreateRoute <| Just package.id)
                [ class "link-with-icon" ]
                [ faSet "kmDetail.createKMEditor" appState
                , lx_ "header.createKMEditor" appState
                ]

        questionnaireAction =
            linkTo appState
                (Routes.QuestionnairesRoute <| Wizard.Questionnaires.Routes.CreateRoute <| Just package.id)
                [ class "link-with-icon" ]
                [ faSet "kmDetail.createQuestionnaire" appState
                , lx_ "header.createQuestionnaire" appState
                ]

        deleteAction =
            a [ onClick <| ShowDeleteDialog True, class "text-danger link-with-icon" ]
                [ faSet "_global.delete" appState
                , lx_ "header.delete" appState
                ]

        actions =
            []
                |> listInsertIf exportAction (hasPerm appState.jwt Perm.packageManagementWrite)
                |> listInsertIf forkAction (hasPerm appState.jwt Perm.knowledgeModel)
                |> listInsertIf questionnaireAction (hasPerm appState.jwt Perm.questionnaire)
                |> listInsertIf deleteAction (hasPerm appState.jwt Perm.packageManagementWrite)
    in
    div [ class "top-header" ]
        [ div [ class "top-header-content" ]
            [ div [ class "top-header-title" ] [ text package.name ]
            , div [ class "top-header-actions" ] actions
            ]
        ]


readme : AppState -> PackageDetail -> Html msg
readme appState package =
    let
        containsNewerVersions =
            (List.length <| List.filter (Version.greaterThan package.version) package.versions) > 0

        warning =
            if containsNewerVersions then
                div [ class "alert alert-warning" ]
                    [ lx_ "readme.versionWarning" appState ]

            else
                newVersionInRegistryWarning appState package
    in
    div [ class "KnowledgeModels__Detail__Readme" ]
        [ warning
        , Markdown.toHtml [ class "readme" ] package.readme
        ]


newVersionInRegistryWarning : AppState -> PackageDetail -> Html msg
newVersionInRegistryWarning appState package =
    case ( package.remoteLatestVersion, PackageState.isOutdated package.state, appState.config.registry ) of
        ( Just remoteLatestVersion, True, RegistryEnabled _ ) ->
            let
                latestPackageId =
                    package.organizationId ++ ":" ++ package.kmId ++ ":" ++ Version.toString remoteLatestVersion
            in
            div [ class "alert alert-warning" ]
                ([ faSet "_global.warning" appState ]
                    ++ lh_ "registryVersion.warning"
                        [ text (Version.toString remoteLatestVersion)
                        , linkTo appState
                            (Routes.KnowledgeModelsRoute <| ImportRoute <| Just <| latestPackageId)
                            []
                            [ lx_ "registryVersion.warning.import" appState ]
                        ]
                        appState
                )

        _ ->
            emptyNode


sidePanel : AppState -> PackageDetail -> Html msg
sidePanel appState package =
    let
        sections =
            [ sidePanelKmInfo appState package
            , sidePanelOtherVersions appState package
            , sidePanelOrganizationInfo appState package
            , sidePanelRegistryLink appState package
            ]
    in
    div [ class "KnowledgeModels__Detail__SidePanel" ]
        [ list 12 12 <| listFilterJust sections ]


sidePanelKmInfo : AppState -> PackageDetail -> Maybe ( String, Html msg )
sidePanelKmInfo appState package =
    let
        kmInfoList =
            [ ( lg "package.id" appState, text package.id )
            , ( lg "package.version" appState, text <| Version.toString package.version )
            , ( lg "package.metamodel" appState, text <| String.fromInt package.metamodelVersion )
            , ( lg "package.license" appState, text package.license )
            ]

        parentInfo =
            case package.forkOfPackageId of
                Just parentPackageId ->
                    [ ( lg "package.forkOf" appState
                      , linkTo appState
                            (Routes.KnowledgeModelsRoute <| DetailRoute parentPackageId)
                            []
                            [ text parentPackageId ]
                      )
                    ]

                Nothing ->
                    []
    in
    Just ( lg "package" appState, list 4 8 <| kmInfoList ++ parentInfo )


sidePanelOtherVersions : AppState -> PackageDetail -> Maybe ( String, Html msg )
sidePanelOtherVersions appState package =
    let
        versionLink version =
            li []
                [ linkTo appState
                    (Routes.KnowledgeModelsRoute <| DetailRoute <| package.organizationId ++ ":" ++ package.kmId ++ ":" ++ Version.toString version)
                    []
                    [ text <| Version.toString version ]
                ]

        versionLinks =
            package.versions
                |> List.filter ((/=) package.version)
                |> List.sortWith Version.compare
                |> List.reverse
                |> List.map versionLink
    in
    if List.length versionLinks > 0 then
        Just ( lg "package.otherVersions" appState, ul [] versionLinks )

    else
        Nothing


sidePanelOrganizationInfo : AppState -> PackageDetail -> Maybe ( String, Html msg )
sidePanelOrganizationInfo appState package =
    case package.organization of
        Just organization ->
            Just ( lg "package.publishedBy" appState, viewOrganization organization )

        Nothing ->
            Nothing


sidePanelRegistryLink : AppState -> PackageDetail -> Maybe ( String, Html msg )
sidePanelRegistryLink appState package =
    case package.registryLink of
        Just registryLink ->
            Just
                ( lg "package.registryLink" appState
                , a [ href registryLink, class "link-with-icon", target "_blank" ]
                    [ faSet "kmDetail.registryLink" appState
                    , text package.id
                    ]
                )

        Nothing ->
            Nothing


list : Int -> Int -> List ( String, Html msg ) -> Html msg
list colLabel colValue rows =
    let
        viewRow ( label, value ) =
            [ dt [ class <| "col-" ++ String.fromInt colLabel ]
                [ text label ]
            , dd [ class <| "col-" ++ String.fromInt colValue ]
                [ value ]
            ]
    in
    dl [ class "row" ] (List.concatMap viewRow rows)


viewOrganization : OrganizationInfo -> Html msg
viewOrganization organization =
    div [ class "organization" ]
        [ ItemIcon.view { text = organization.name, image = organization.logo }
        , div [ class "content" ]
            [ strong [] [ text organization.name ]
            , br [] []
            , text organization.organizationId
            ]
        ]


deleteVersionModal : AppState -> Model -> PackageDetail -> Html Msg
deleteVersionModal appState model package =
    let
        modalContent =
            [ p []
                (lh_ "deleteModal.message" [ strong [] [ text package.id ] ] appState)
            ]

        modalConfig =
            { modalTitle = l_ "deleteModal.title" appState
            , modalContent = modalContent
            , visible = model.showDeleteDialog
            , actionResult = model.deletingVersion
            , actionName = l_ "deleteModal.action" appState
            , actionMsg = DeleteVersion
            , cancelMsg = Just <| ShowDeleteDialog False
            , dangerous = True
            }
    in
    Modal.confirm appState modalConfig
