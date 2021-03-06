module Wizard exposing (main)

import Browser
import Browser.Navigation exposing (Key)
import Json.Decode exposing (Value)
import Url exposing (Url)
import Wizard.Common.AppState as AppState
import Wizard.Common.Time as Time
import Wizard.Models exposing (..)
import Wizard.Msgs exposing (Msg)
import Wizard.Public.Routes
import Wizard.Routes as Routes
import Wizard.Routing as Routing exposing (cmdNavigate, homeRoute, routeIfAllowed)
import Wizard.Subscriptions exposing (subscriptions)
import Wizard.Update exposing (fetchData, update)
import Wizard.View exposing (view)


init : Value -> Url -> Key -> ( Model, Cmd Msg )
init flags location key =
    let
        route =
            location
                |> Routing.parseLocation appState
                |> routeIfAllowed appState.jwt

        appState =
            AppState.init flags key

        appStateWithRoute =
            { appState | route = route }

        model =
            initLocalModel <| initialModel appStateWithRoute
    in
    ( model
    , Cmd.batch
        [ decideInitialRoute model route
        , Time.getTime
        ]
    )


decideInitialRoute : Model -> Routes.Route -> Cmd Msg
decideInitialRoute model route =
    case route of
        Routes.PublicRoute subroute ->
            case ( userLoggedIn model, subroute ) of
                ( True, Wizard.Public.Routes.BookReferenceRoute _ ) ->
                    fetchData model

                ( True, Wizard.Public.Routes.QuestionnaireRoute ) ->
                    fetchData model

                ( True, _ ) ->
                    cmdNavigate model.appState Routes.DashboardRoute

                _ ->
                    fetchData model

        _ ->
            if userLoggedIn model then
                fetchData model

            else
                cmdNavigate model.appState homeRoute


main : Program Value Model Msg
main =
    Browser.application
        { init = init
        , onUrlChange = Wizard.Msgs.OnUrlChange
        , onUrlRequest = Wizard.Msgs.OnUrlRequest
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
