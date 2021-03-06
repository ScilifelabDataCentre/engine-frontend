module Wizard.Common.Api.Users exposing (deleteUser, getCurrentUser, getUser, getUsers, postUser, postUserPublic, putUser, putUserActivation, putUserPassword, putUserPasswordPublic)

import Json.Decode as D
import Json.Encode as Encode exposing (Value)
import Wizard.Common.Api exposing (ToMsg, httpPost, httpPut, jwtDelete, jwtGet, jwtPost, jwtPut)
import Wizard.Common.AppState exposing (AppState)
import Wizard.Users.Common.User as User exposing (User)


getUsers : AppState -> ToMsg (List User) msg -> Cmd msg
getUsers =
    jwtGet "/users" (D.list User.decoder)


getUser : String -> AppState -> ToMsg User msg -> Cmd msg
getUser uuid =
    jwtGet ("/users/" ++ uuid) User.decoder


getCurrentUser : AppState -> ToMsg User msg -> Cmd msg
getCurrentUser =
    jwtGet "/users/current" User.decoder


postUser : Value -> AppState -> ToMsg () msg -> Cmd msg
postUser =
    jwtPost "/users"


postUserPublic : Value -> AppState -> ToMsg () msg -> Cmd msg
postUserPublic =
    httpPost "/users"


putUser : String -> Value -> AppState -> ToMsg () msg -> Cmd msg
putUser uuid =
    jwtPut ("/users/" ++ uuid)


putUserPassword : String -> Value -> AppState -> ToMsg () msg -> Cmd msg
putUserPassword uuid =
    jwtPut ("/users/" ++ uuid ++ "/password")


putUserPasswordPublic : String -> String -> Value -> AppState -> ToMsg () msg -> Cmd msg
putUserPasswordPublic uuid hash =
    httpPut ("/users/" ++ uuid ++ "/password?hash=" ++ hash)


putUserActivation : String -> String -> AppState -> ToMsg () msg -> Cmd msg
putUserActivation uuid hash =
    let
        body =
            Encode.object [ ( "active", Encode.bool True ) ]
    in
    httpPut ("/users/" ++ uuid ++ "/state?hash=" ++ hash) body


deleteUser : String -> AppState -> ToMsg () msg -> Cmd msg
deleteUser uuid =
    jwtDelete ("/users/" ++ uuid)
