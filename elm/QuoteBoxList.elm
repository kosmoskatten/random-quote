module QuoteBoxList
        ( Model
        , init
        , update
        , view
        ) where

import Effects exposing (Effects, Never)
import Html exposing (Attribute, Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (..)
import Task
import QuoteBox

type alias Id = Int

type alias Model =
    { quoteBoxList : List (Id, QuoteBox.Model)
    , nextId       : Id
    }

type Action 
    = RequestQuote
    | GotQuote (Maybe Quote)
    | DelQuote Id

type alias Quote =
    { author : String
    , imgUrl : String
    , quote  : String
    }

init : (Model, Effects Action)
init =
   ( { quoteBoxList = [], nextId = 0 }
   , Effects.none
   )

update : Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        RequestQuote        -> (model, getRandomQuote)
        GotQuote maybeQuote -> 
            (maybeAddQuote model maybeQuote, Effects.none)
        DelQuote id         ->
            let xs = List.filter (\(id', _) -> id' /= id) model.quoteBoxList
            in ( { model | quoteBoxList <- xs }
               , Effects.none
               )

maybeAddQuote : Model -> Maybe Quote -> Model
maybeAddQuote model maybeQuote =
    case maybeQuote of
        Just q  ->
            let currId   = model.nextId
                quoteBox = (currId, QuoteBox.init q.author q.imgUrl q.quote)
            in { model | nextId <- currId + 1
                       , quoteBoxList <- quoteBox :: model.quoteBoxList
               }
        Nothing -> model

view : Signal.Address Action -> Model -> Html
view address model =
    let btn = button 
                [ buttonStyles
                , onClick address RequestQuote
                ] 
                [ text "Add random quote!" ]
        qts = List.map (viewQuote address) model.quoteBoxList
    in div [ panelStyles ] (btn :: qts)

viewQuote : Signal.Address Action -> (Id, QuoteBox.Model) -> Html
viewQuote address (id, model) =
    QuoteBox.view (Signal.forwardTo address (always (DelQuote id))) model

(=>) : a -> b -> (a, b)
(=>) = (,)

buttonStyles : Attribute
buttonStyles =
    style
      [ "width"  => "100%"
      , "height" => "20px"
      ]

panelStyles : Attribute
panelStyles =
    style
      [ "width"            => "768px"
      , "height"           => "100%"
      , "background-color" => "black"
      ]

getRandomQuote : Effects Action
getRandomQuote =
    Http.get decodeQuote "/api/random-quote"
      |> Task.toMaybe
      |> Task.map GotQuote
      |> Effects.task

decodeQuote : Decoder Quote
decodeQuote = 
    object3 Quote
      ( "author" := string )
      ( "imgUrl" := string )
      ( "quote"  := string )
