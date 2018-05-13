module Public.Login.View exposing (view)

import Common.Html exposing (linkTo)
import Common.View.Forms exposing (actionButton, formResultView, submitButton)
import Html exposing (..)
import Html.Attributes exposing (class, disabled, placeholder, type_)
import Html.Events exposing (..)
import Msgs
import Public.Login.Models exposing (Model)
import Public.Login.Msgs exposing (Msg(..))
import Public.Routing exposing (Route(ForgottenPassword))
import Routing exposing (Route(Public))


view : (Msg -> Msgs.Msg) -> Model -> Html Msgs.Msg
view wrapMsg model =
    div [ class "Public__Login" ]
        [ loginForm wrapMsg model ]


loginForm : (Msg -> Msgs.Msg) -> Model -> Html Msgs.Msg
loginForm wrapMsg model =
    form [ onSubmit (wrapMsg Login), class "well col-xs-10 col-xs-offset-1 col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3 col-lg-4 col-lg-offset-4" ]
        [ fieldset []
            [ legend [] [ text "Log in" ]
            , formResultView model.loggingIn
            , div [ class "form-group" ]
                [ label [ class "control-label" ]
                    [ text "Email" ]
                , input [ onInput (wrapMsg << Email), type_ "text", class "form-control", placeholder "Email" ] []
                ]
            , div [ class "form-group" ]
                [ label [ class "control-label" ]
                    [ text "Password" ]
                , input [ onInput (wrapMsg << Password), type_ "password", class "form-control", placeholder "Password" ] []
                ]
            , div [ class "form-group row Public__Login__FormButtons" ]
                [ div [ class "col-xs-6" ]
                    [ linkTo (Public ForgottenPassword) [] [ text "Forgot your password?" ] ]
                , div [ class "col-xs-6 text-right" ]
                    [ submitButton ( "Log in", model.loggingIn ) ]
                ]
            ]
        ]
