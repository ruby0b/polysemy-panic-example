module Main where

import OneModule
import OtherModule
import Polysemy
import Polysemy.Error

printStrErrors :: (Member (Embed IO) r) => Sem (Error String : r) a2 -> Sem r ()
printStrErrors err =
  runError err >>= \case
    Left msg -> embed $ print msg
    Right _ -> return ()

printIntErrors :: (Member (Embed IO) r) => Sem (Error Int : r) a2 -> Sem r ()
printIntErrors err =
  runError err >>= \case
    Left msg -> embed $ print msg
    Right _ -> return ()

main :: IO ()
main =
  runFinal
    . embedToFinal
    . printStrErrors
    . printIntErrors
    $ do
      polyMain
      polyMain2
