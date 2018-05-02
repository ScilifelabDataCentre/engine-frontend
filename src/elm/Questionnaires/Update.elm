module Questionnaires.Update exposing (..)

import Auth.Models exposing (Session)
import Msgs
import Questionnaires.Create.Update
import Questionnaires.Detail.Update
import Questionnaires.Index.Update
import Questionnaires.Models exposing (Model)
import Questionnaires.Msgs exposing (Msg(..))
import Questionnaires.Routing exposing (Route(..))


fetchData : Route -> (Msg -> Msgs.Msg) -> Session -> Cmd Msgs.Msg
fetchData route wrapMsg session =
    case route of
        Index ->
            Questionnaires.Index.Update.fetchData (wrapMsg << IndexMsg) session

        _ ->
            Cmd.none


update : Msg -> (Msg -> Msgs.Msg) -> Model -> ( Model, Cmd Msgs.Msg )
update msg wrapMsg model =
    case msg of
        CreateMsg msg ->
            let
                ( createModel, cmd ) =
                    Questionnaires.Create.Update.update msg (wrapMsg << CreateMsg) model.createModel
            in
            ( { model | createModel = createModel }, cmd )

        DetailMsg msg ->
            let
                ( detailModel, cmd ) =
                    Questionnaires.Detail.Update.update msg (wrapMsg << DetailMsg) model.detailModel
            in
            ( { model | detailModel = detailModel }, cmd )

        IndexMsg msg ->
            let
                ( indexModel, cmd ) =
                    Questionnaires.Index.Update.update msg (wrapMsg << IndexMsg) model.indexModel
            in
            ( { model | indexModel = indexModel }, cmd )