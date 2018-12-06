module WsDemo.Display where

import Prelude

import Halogen as H
import Halogen.HTML as HH
import Data.Maybe (Maybe(..))
import WsDemo.Model (Message, Load)

data Query a = UpdateMessage Message a

data State = State Load

statsDisplay :: forall m. H.Component HH.HTML Query Unit Message m
statsDisplay =
  H.component
    { initialState: const initialState
    , render
    , eval
    , receiver: const Nothing
    }
  where

  initialState :: State
  initialState = State { avg1: 0, avg5: 0, avg15: 0 }

  render :: State -> H.ComponentHTML Query
  render (State { avg1, avg5, avg15 }) =
    HH.ul_
      [ HH.li_ [ HH.text $ show avg1 ]
      , HH.li_ [ HH.text $ show avg5 ]
      , HH.li_ [ HH.text $ show avg15 ]
      ]

  eval :: Query ~> H.ComponentDSL State Query Message m
  eval = case _ of
    UpdateMessage { load } next -> do
      state <- H.put $ State load
      pure next