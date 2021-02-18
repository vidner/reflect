module Pages.Top exposing (Model, Msg, Params, page)

import Decoders exposing (..)
import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Http
import Palette
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)
import Typeface
import Url


type alias Params =
    ()


type alias Model =
    { msg : String, response : Response }


type Msg
    = OnResponse (Result Http.Error Response)


type alias Profile =
    { name : String, bio : String }


type alias Blog =
    { title : String, url : String, date : String }


type alias Project =
    { name : String, url : String, description : String }


type alias Achievement =
    { title : String, description : String }


type alias Response =
    { profile : Profile, blogs : List Blog, projects : List Project, achivements : List Achievement }


page : Page Params Model Msg
page =
    Page.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


init : Url Params -> ( Model, Cmd Msg )
init url =
    ( Model "" (Response (Profile "" "") [] [] []), getResponse url.rawUrl )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnResponse res ->
            case res of
                Ok data ->
                    ( { model | response = data }, Cmd.none )

                Err httpErr ->
                    ( { model | msg = handleHttpError httpErr }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Document Msg
view model =
    { title = model.response.profile.name
    , body =
        [ profile model.response.profile
        , projects model.response.projects
        , blogs model.response.blogs
        , achivements model.response.achivements
        ]
    }


handleHttpError : Http.Error -> String
handleHttpError error =
    case error of
        Http.BadUrl url ->
            "The URL " ++ url ++ " was invalid"

        Http.Timeout ->
            "Unable to reach the server, try again"

        Http.NetworkError ->
            "Unable to reach the server, check your network connection"

        Http.BadStatus 500 ->
            "The server had a problem, try again later"

        Http.BadStatus 400 ->
            "Verify your information and try again"

        Http.BadStatus _ ->
            "Unknown error"

        Http.BadBody errorMessage ->
            errorMessage


getResponse url =
    Http.get
        { url = Url.toString url ++ "/data.json"
        , expect = Http.expectJson OnResponse responseDecoder
        }


profile data =
    column [ spacing 10, width (px 600) ]
        [ el [ Font.size 69, Font.extraBold, Typeface.cantarell ] (text data.name)
        , paragraph [ Font.size 20, Font.light, Font.color Palette.medium, Typeface.fira ] [ text data.bio ]
        ]


projects data =
    column [ paddingXY 0 40, spacing 15 ]
        [ el [ Font.size 30, Font.bold, Typeface.cantarell, width fill ] (text "Projects")
        , wrappedRow [ Font.size 20, Font.medium, Font.color Palette.medium, spacing 20, Typeface.fira ] <|
            List.map projectsEntry data
        ]


blogs data =
    column [ paddingXY 0 40, spacing 15 ]
        [ el [ Font.size 30, Font.bold, Typeface.cantarell ] (text "Blog")
        , column [ padding 5, Font.size 20, Font.medium, Font.color Palette.dark, spacing 20, Typeface.fira ] <|
            List.map blogsEntry data
        ]


achivements data =
    column [ paddingXY 0 40, spacing 15 ]
        [ el [ Font.size 30, Font.bold, Typeface.cantarell ] (text "Achievements")
        , column [ padding 5, Font.size 20, Font.medium, Font.color Palette.dark, spacing 20, Typeface.fira ] <|
            List.map achievementsEntry data
        ]


projectsEntry data =
    column
        [ spacing 5
        , Border.color Palette.blue
        , Border.rounded 5
        , Border.width 1
        , padding 15
        , height (px 100)
        , mouseOver [ Border.shadow { offset = ( 0.5, 0.5 ), size = 1.0, blur = 1.0, color = Palette.white } ]
        , width (px 450)
        ]
        [ link [ Font.color Palette.dark ] { url = data.url, label = text data.name }
        , paragraph [ Font.size 18, Font.light, Font.color Palette.light, Typeface.fira ] [ text data.description ]
        ]


blogsEntry data =
    column [ spacing 5 ]
        [ link [ Font.color Palette.blue ] { url = data.url, label = text data.title }
        , el [ Font.size 18, Font.light, Font.color Palette.light, Typeface.fira ] (text data.date)
        ]


achievementsEntry data =
    column [ spacing 8 ]
        [ el [ Font.color Palette.black ] (text data.title)
        , el [ Font.size 18, Font.light, Font.color Palette.light, Typeface.fira ] (text data.description)
        ]
