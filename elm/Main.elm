import Effects exposing (Never)
import Html exposing (Html)
import StartApp
import Task

import QuoteBoxList exposing (init, update, view)

app = 
    StartApp.start 
      { init   = init
      , update = update
      , view   = view
      , inputs = []
      }

main : Signal Html
main = app.html

port tasks : Signal (Task.Task Never ())
port tasks = app.tasks
