module Wizard.Common.Api.Organizations exposing
    ( getCurrentOrganization
    , putCurrentOrganization
    )

import Json.Encode exposing (Value)
import Wizard.Common.Api exposing (ToMsg, jwtGet, jwtPut)
import Wizard.Common.AppState exposing (AppState)
import Wizard.Organization.Common.Organization as Organization exposing (Organization)


getCurrentOrganization : AppState -> ToMsg Organization msg -> Cmd msg
getCurrentOrganization =
    jwtGet "/organizations/current" Organization.decoder


putCurrentOrganization : Value -> AppState -> ToMsg () msg -> Cmd msg
putCurrentOrganization =
    jwtPut "/organizations/current"
