module Public.View exposing (view)

import Html exposing (Html)
import Msgs
import Public.ForgottenPassword.View
import Public.Home.View
import Public.Login.View
import Public.Models exposing (Model)
import Public.Msgs exposing (Msg(..))
import Public.Routing exposing (Route(..))
import Public.Signup.View


view : Route -> (Msg -> Msgs.Msg) -> Model -> Html Msgs.Msg
view route wrapMsg model =
    case route of
        ForgottenPassword ->
            Public.ForgottenPassword.View.view

        Home ->
            Public.Home.View.view

        Login ->
            Public.Login.View.view (wrapMsg << LoginMsg) model.loginModel

        Signup ->
            Public.Signup.View.view