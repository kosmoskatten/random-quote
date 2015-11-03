module RandomQuote
        ( RandomQuote
        , Quote
        , init
        , genQuote
        ) where

import Array exposing (Array)
import Random exposing (Generator, Seed, initialSeed, int, generate)

type alias Quote =
    { author : String
    , imgUrl : String
    , quote  : String
    }

type alias RandomQuote =
    { seed   : Seed
    , gen    : Generator Int
    , quotes : Array Quote
    }

init : RandomQuote
init =
    let quotes' = mkQuotes
    in { seed = initialSeed 42
       , gen = int 0 (Array.length quotes' - 1)
       , quotes = quotes'
       }

genQuote : RandomQuote -> (Quote, RandomQuote)
genQuote rq = 
    let (index, seed') = generate rq.gen rq.seed
        quote         = case Array.get index rq.quotes of
                            Just q  -> q
                            Nothing -> Quote "Error" "Error" "Error"
    in (quote, { rq | seed <- seed' })

mkQuotes : Array Quote
mkQuotes = 
    Array.fromList 
      [ { author = "Linus Torvalds"
        , imgUrl = "images/Linus-Torvalds.jpg"
        , quote  = "Talk is cheap, show me the code"
        }
      , { author = "Linus Torvalds"
        , imgUrl = "images/Linus-Torvalds.jpg"
        , quote  = """
                   No-one has even called me a cool dude. I'm
                   somewhere between geek and normal.
                   """
        }
      , { author = "Linus Torvalds"
        , imgUrl = "images/Linus-Torvalds.jpg"
        , quote  = "Software is like sex: its better when its free."
        }
      , { author = "Dennis M Ritchie"
        , imgUrl = "images/dennis_macalistair_ritchie_.jpeg"
        , quote  = "C is quirky, flawed, and an enormous success."
        }
      ]
