import List
import Dict
import String
import Basics
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode
import Json.Decode as Decode
import Json.Encode as Encode

-- Types
type alias ServerResult = {}

type alias InputFlags =
    { placeholder: String
    , serverUrl: String
    }

type alias Model =
    { placeholder : String
    , serverUrl : String
    , buttonClicked : Bool
    , response : Maybe ServerResult
    , error : Maybe Http.Error
    }

type Msg
    = NoOp
    | ButtonClicked
    | Response (Result Http.Error ServerResult)


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ButtonClicked ->
            ( { model | buttonClicked = True }, Cmd.none )

        Response (Ok response) ->
            ( { model | error = Nothing, response = Just response }, Cmd.none )

        Response (Err error) ->
            ( { model | error = Just error, response = Nothing }, Cmd.none )



-- HTTP


-- HELPERS



-- VIEWS



viewResponse : ServerResult -> Html Msg
viewResponse response =
    div [ class "response-container" ]
        [ h2 [] [ text "Results" ]
        , div []
            [ text "here" ]
        ]


viewError : Http.Error -> Html Msg
viewError error =
    div [ class "error-container" ]
        [ h2 [] [ text "Search Errors" ]
        , div [] (case error of
            Http.BadUrl url ->
                [ text ("Bad URL: " ++ url)]
            Http.Timeout ->
                [ text "Network timeout" ]
            Http.NetworkError ->
                [ text "Network error" ]
            Http.BadStatus code ->
                [ text ("Bad status: " ++ String.fromInt code) ]
            Http.BadBody body ->
                [ text body ]
        )
        ]


viewUtils :
    { a | error : Maybe Http.Error, response : Maybe ServerResult }
    -> ({ a | error : Maybe Http.Error, response : Maybe ServerResult } -> Html Msg)
    -> Html Msg
viewUtils model viewF =
    div []
        [ viewF model
        , case model.response of
            Just response ->
                viewResponse response

            Nothing ->
                text ""
        , case model.error of
            Just error ->
                viewError error

            Nothing ->
                text ""
        ]


view : Model -> Html Msg
view model =
    viewUtils model viewForm


viewForm : Model -> Html Msg
viewForm model =
    Html.div
        [ class "runthis-container" ]
        [ button
            [ onClick ButtonClicked ]
            [ text "Run This" ]
        , br [] []
        , div [ class "runthis-contents" ]
            [ if model.buttonClicked then
                iframe [ src model.serverUrl ] []
              else
                p [] [ text model.placeholder ]
            ]
        ]


init : InputFlags -> ( Model, Cmd Msg )
init flags =
    ( { placeholder = flags.placeholder
      , serverUrl = flags.serverUrl
      , buttonClicked = False
      , response = Nothing
      , error = Nothing
      }
    , Cmd.none
    )


-- MAIN

main : Program InputFlags Model Msg
main =
  Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
