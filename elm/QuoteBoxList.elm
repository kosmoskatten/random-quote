module QuoteBoxList
        ( Model
        , init
        , update
        , view
        ) where

import Html exposing (Attribute, Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import RandomQuote exposing (RandomQuote)
import QuoteBox

type alias Id = Int

type alias Model =
    { randomQuote  : RandomQuote
    , quoteBoxList : List (Id, QuoteBox.Model)
    , nextId       : Id
    }

type Action 
    = AddQuote
    | DelQuote Id

init : Model
init = { randomQuote = RandomQuote.init, quoteBoxList = [], nextId = 0 }

update : Action -> Model -> Model
update action model =
    case action of
        AddQuote -> 
            let (newQuote, randomQuote') = 
                    RandomQuote.genQuote model.randomQuote
                newQuote' = QuoteBox.Model newQuote.author
                                           newQuote.imgUrl
                                           newQuote.quote
            in { model | randomQuote <- randomQuote' 
                       , quoteBoxList <-
                             (model.nextId, newQuote') :: model.quoteBoxList
                       , nextId <- model.nextId + 1
               }

        DelQuote id ->
            let xs = List.filter (\(id', _) -> id' /= id) model.quoteBoxList
            in { model | quoteBoxList <- xs }

view : Signal.Address Action -> Model -> Html
view address model =
    let btn = button 
                [ buttonStyles
                , onClick address AddQuote
                ] 
                [ text "Add random quote!" ]
        qts = List.map (viewQuote address) model.quoteBoxList
    in div [ panelStyles ] (btn :: qts)

viewQuote : Signal.Address Action -> (Id, QuoteBox.Model) -> Html
viewQuote address (id, model) =
    QuoteBox.view (Signal.forwardTo address (always (DelQuote id))) model

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
