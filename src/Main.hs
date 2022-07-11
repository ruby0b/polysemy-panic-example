{-# LANGUAGE OverloadedStrings #-}

module Main where

import Calamity (Token (BotToken), defaultIntents, runBotIO)
import Calamity.Cache.InMemory (runCacheInMemory)
import Calamity.Commands (addCommands, useConstantPrefix)
import Calamity.Commands.Context (useFullContext)
import Calamity.Metrics.Noop (runMetricsNoop)
import Data.Functor (void)
import qualified Di
import qualified DiPolysemy as DiP
import PanicModule (MyError, panicCommand)
import qualified Polysemy as P
import Polysemy.Error

printStrErrors :: (P.Member (P.Embed IO) r) => P.Sem (Error String : r) a2 -> P.Sem r ()
printStrErrors err =
  runError err >>= \case
    Left msg -> P.embed $ putStrLn msg
    Right _ -> return ()

printFancyStrErrors :: (P.Member (P.Embed IO) r) => P.Sem (Error MyError : r) a2 -> P.Sem r ()
printFancyStrErrors err =
  runError err >>= \case
    Left msg -> P.embed $ putStrLn $ "Fancy Error: " ++ show msg
    Right _ -> return ()

main :: IO ()
main = do
  let token = "MY_FAKE_TOKEN"
  Di.new $ \di -> void
    . P.runFinal
    . P.embedToFinal
    . DiP.runDiToIO di
    . printStrErrors
    . printFancyStrErrors
    . runCacheInMemory
    . runMetricsNoop
    . useConstantPrefix "="
    . useFullContext
    . runBotIO (BotToken token) defaultIntents
    $ addCommands $ do
      panicCommand
