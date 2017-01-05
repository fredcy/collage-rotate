module Main exposing (main)

import Html
import Collage
import Element
import Transform
import Time


type alias Model =
    Float


type Msg
    = Tick Float


main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( 0, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            ( model + pi / 30, Cmd.none )


view : Model -> Html.Html Msg
view model =
    let
        pathForm =
            Collage.path [ ( 30, 30 ), ( 50, 50 ) ]
                |> Collage.traced Collage.defaultLine
                |> rotateAbout ( 30, 30 ) model
    in
        Collage.collage 200 200 [ pathForm ] |> Element.toHtml


rotateAbout : ( Float, Float ) -> Float -> Collage.Form -> Collage.Form
rotateAbout (( x, y ) as center) angle form =
    let
        ( xr, yr ) =
            rotatePoint angle center
    in
        form |> Collage.rotate angle |> Collage.move ( x - xr, y - yr )


rotatePoint : Float -> ( Float, Float ) -> ( Float, Float )
rotatePoint angle (( x, y ) as point) =
    let
        xr =
            cos angle * x - sin angle * y

        yr =
            sin angle * x + cos angle * y
    in
        ( xr, yr )


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every Time.second Tick
