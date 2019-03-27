module KnowledgeModels.Routing exposing (Route(..), detail, isAllowed, moduleRoot, parsers, toUrl)

import Auth.Models exposing (JwtToken)
import Auth.Permission as Perm exposing (hasPerm)
import Url.Parser exposing (..)


type Route
    = Detail String String
    | Import
    | Index


moduleRoot : String
moduleRoot =
    "knowledge-models"


parsers : (Route -> a) -> List (Parser (a -> c) c)
parsers wrapRoute =
    [ map (detail wrapRoute) (s moduleRoot </> s "package" </> string </> string)
    , map (wrapRoute <| Import) (s moduleRoot </> s "import")
    , map (wrapRoute <| Index) (s moduleRoot)
    ]


detail : (Route -> a) -> String -> String -> a
detail wrapRoute organizationId kmId =
    Detail organizationId kmId |> wrapRoute


toUrl : Route -> List String
toUrl route =
    case route of
        Detail organizationId kmId ->
            [ moduleRoot, "package", organizationId, kmId ]

        Import ->
            [ moduleRoot, "import" ]

        Index ->
            [ moduleRoot ]


isAllowed : Route -> Maybe JwtToken -> Bool
isAllowed route maybeJwt =
    case route of
        Import ->
            hasPerm maybeJwt Perm.packageManagementWrite

        _ ->
            hasPerm maybeJwt Perm.packageManagementRead