import Html exposing (Html)
import StartApp.Simple as StartApp

import QuoteBoxList exposing (..)

main : Signal Html
main = StartApp.start { model = init, update = update, view = view }
