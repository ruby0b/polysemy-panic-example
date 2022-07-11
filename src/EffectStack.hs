{-# LANGUAGE ConstraintKinds #-}

module EffectStack where

import Polysemy
import Polysemy.Error

type MyEffects r = Members '[Embed IO, Error String, Error Int] r
