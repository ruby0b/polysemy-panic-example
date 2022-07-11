module OneModule where

import EffectStack
import Polysemy
import Polysemy.Error

polyMain :: MyEffects r => Sem r ()
polyMain = do
  embed $ putStrLn "Embed: Hello!"
  if (2 :: Int) > 1
    then throw "Hi, this is a string error!"
    else throw (7 :: Int)
