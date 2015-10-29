--| A 'quote box' widget, displaying a quote, its author and the 
-- author's image.
module QuoteBox 
    ( Model
    , Action
    , init
    , update
    , view
    ) where

import Html exposing (Attribute, Html, div, i, img, p, text)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)

type alias Model =
    { author   : String
    , imageUrl : String
    , quote    : String
    }

type alias Action = ()

init : String -> String -> String -> Model
init author imageUrl quote =
    { author = author, imageUrl = imageUrl, quote = quote }

update : Action -> Model -> Model
update () model = model

view : Signal.Address Action -> Model -> Html
view address model =
    div [ quoteBoxStyle ]
        [ div [ imageBoxStyle ] 
              [ img [ imageStyle, src model.imageUrl ] []
              ]
        , div [ textBoxStyle ]
              [ text model.author
              , p [] [ i [] [ text model.quote ] ]  
              ]
        , div [ closingBoxStyle 
              , onClick address ()
              ]
              [ text "x" ]
        ]

(=>) = (,)

quoteBoxStyle : Attribute
quoteBoxStyle =
    style
      [ "background-color" => "black"
      , "width"            => "100%"
      , "height"           => "100px"
      , "border"           => "1px solid gray"
      ]

imageBoxStyle : Attribute
imageBoxStyle =
    style
      [ "width"            => "80px"
      , "height"           => "80px"
      , "margin"           => "10px"
      , "float"            => "left"
      , "background-color" => "black"
      ]

imageStyle : Attribute
imageStyle =
    style
      [ "height"        => "100%"
      , "width"         => "100%"
      , "object-fit"    => "contain"
      , "border-radius" => "12px"
      ]

textBoxStyle : Attribute
textBoxStyle =
    style
      [ "height" => "80px"
    --  , "width"  => "100%"
      , "background-color" => "black"
      , "color" => "lightgray"
      , "margin" => "10px"
      , "float" => "left"
      ]

closingBoxStyle : Attribute
closingBoxStyle =
    style
      [ "height" => "15px"
      , "width"  => "15px"
      , "display" => "flex"
      , "align-items" => "center"
      , "justify-content" => "center"
      , "margin" => "10px"
      , "background-color" => "black"
      , "color" => "lightgray"
      , "float" => "right"
      , "border" => "1px solid lightgray"
      ]
