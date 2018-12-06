module WsDemo.Cpu (avg1, avg5, avg15) where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)

foreign import avg1_ :: Maybe Int -> (Int -> Maybe Int) -> Effect (Maybe Int)

avg1 :: Effect (Maybe Int)
avg1 = avg1_ Nothing Just

foreign import avg5_ :: Maybe Int -> (Int -> Maybe Int) -> Effect (Maybe Int)

avg5 :: Effect (Maybe Int)
avg5 = avg5_ Nothing Just

foreign import avg15_ :: Maybe Int -> (Int -> Maybe Int) -> Effect (Maybe Int)

avg15 :: Effect (Maybe Int)
avg15 = avg15_ Nothing Just