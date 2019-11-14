import List
import Dict
import String
import Basics
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (string, field, maybe, bool)
import Json.Decode as Decode
import Json.Encode as Encode
import Json.Decode.Pipeline exposing (optional, optionalAt, required, requiredAt)

-- Types

type alias Model =
    { placeholder : String
    , serverUrl : String
    , setup: String
    , started : Bool
    , flagsError : String
    }

type Msg
    = NoOp
    | ButtonClicked


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ButtonClicked ->
            ( { model | started = True }, Cmd.none )



-- HTTP


-- HELPERS



-- VIEWS

view : Model -> Html Msg
view model =
    Html.div
        [ class "runthis-container" ]
        [ button
            [ onClick ButtonClicked ]
            [ text "Run This" ]
        , br [] []
        , div [ class "runthis-contents" ]
            [ if not (String.isEmpty model.flagsError) then
                p [] [ h2 [] [text "JSON Flags Error"]
                     , text model.flagsError
                     ]
              else if model.started then
                iframe [ src (model.serverUrl ++ "?setup=print"), style "width" "100%", height 400 ] []
              else
                p [] [ text model.placeholder ]
            ]
        ]



-- MAIN

modelDecoder : Decode.Decoder Model
modelDecoder =
    Decode.succeed Model
        |> required "placeholder" string
        |> required "serverUrl" string
        |> required "setup" string
        |> optional "started" bool False
        |> optional "flagsError" string ""

init : Decode.Value -> ( Model, Cmd Msg )
init flags =
    ( case (Decode.decodeValue modelDecoder flags) of
        Ok value ->
            value
        Err error ->
            { placeholder = ""
            , serverUrl = ""
            , setup = ""
            , started = False
            , flagsError = Decode.errorToString error
            }
    , Cmd.none
    )

main : Program Decode.Value Model Msg
main =
  Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
