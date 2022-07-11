module OtherModule where

import EffectStack (MyEffects)
import Polysemy
import Polysemy.Error

polyMain2 :: MyEffects r => Sem r ()
polyMain2 =
  if (2 :: Int) > 1
    then throw "Hi, this is a string error!"
    else throw (7 :: Int)
