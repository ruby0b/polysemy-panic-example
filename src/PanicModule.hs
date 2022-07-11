{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module PanicModule where

import Calamity (BotC)
import Calamity.Commands (DSLC, command)
import Calamity.Commands.Context (FullContext)
import Data.Functor (void)
import Data.String.Interpolate (i)
import Optics (view)
import qualified Polysemy as P
import qualified Polysemy.Error as P

data MyError = MyError deriving (Show)

maybeThrow :: P.Member (P.Error e) r => e -> Maybe a -> P.Sem r a
maybeThrow err = maybe (P.throw err) return

panicCommand :: (P.Members '[P.Error MyError, P.Error String] r, BotC r, DSLC FullContext r) => P.Sem r ()
panicCommand = void $
  command @'[] "panic" $
    \ctx -> do
      let x :: Maybe Int = Nothing
      let err = [i|Unexpected #{x}!|]

      -- !!! The panic can be stopped by doing any of the following:
      -- + commenting out either of the next 2 lines
      -- + annotating the type of err
      -- + annotating the type of ctx
      _ <- maybeThrow err x
      let user = view #user ctx

      return ()
