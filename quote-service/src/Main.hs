{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
module Main
    ( main
    ) where

import Control.Monad.IO.Class (liftIO)
import Data.Aeson
import Data.Text (Text)
import GHC.Generics
import Network.HTTP.Types
import Network.Wai
import Network.Wai.Handler.Warp (run)
import qualified Data.ByteString.Char8 as BS

data Quote =
    Quote { author :: !Text
          , imgUrl :: !Text
          , quote  :: !Text
          }
    deriving (Generic, Show)

instance ToJSON Quote

main :: IO ()
main = run 8080 router

router :: Application
router request responseReceived = do
    response <-
        case rawPathInfo request of
            "/api/random-quote" -> do
                quote' <- getRandomQuote
                return $ responseLBS status200 [ mediaJson ] (encode quote')
            _                 -> serveDirectory "static" request

    responseReceived response

getRandomQuote :: IO Quote
getRandomQuote = do
    liftIO $ putStrLn "getRandomQuote called"
    return $ Quote "Linus Torvalds"
                   "images/Linus-Torvalds.jpg"
                   "Talk is cheap. Show me the code."

serveDirectory :: FilePath -> Request -> IO Response
serveDirectory directory request = do
    let reqFile = BS.unpack (rawPathInfo request)
        path    = directory `mappend` "/" `mappend` reqFile
    return $ responseFile status200 [] path Nothing

mediaJson :: Header
mediaJson = ("Content-Type", "application/json")
