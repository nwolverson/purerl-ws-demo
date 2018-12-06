module WsSpork.Client where

import Prelude

import Data.Foldable (for_)
import Effect (Effect)
import Simple.JSON as SimpleJSON
import Spork.Html (Html)
import Spork.Html as H
import Spork.PureApp (PureApp)
import Spork.PureApp as PureApp
import WsDemo.Model (Message, Load)
import WsSpork.Socket (createSocket)

type Model = Load

data Action = UpdateMessage Message

update ∷ Model → Action → Model
update _ = case _ of
  UpdateMessage { load } → load

render ∷ Model → Html Action
render { avg1, avg5, avg15 } =
  H.ul []
    [ H.li [] [ H.text $ show avg1 ]
    , H.li [] [ H.text $ show avg5 ]
    , H.li [] [ H.text $ show avg15 ]
    ]

app ∷ PureApp Model Action
app = { update, render, init: { avg1: 0, avg5: 0, avg15: 0 } }

main ∷ Effect Unit
main = do
    appInstance <- PureApp.makeWithSelector app "#app"
    createSocket "ws://localhost:8082/ws" \json -> 
        for_ (SimpleJSON.readJSON json) \msg -> do
            appInstance.push $ UpdateMessage msg
            appInstance.run
