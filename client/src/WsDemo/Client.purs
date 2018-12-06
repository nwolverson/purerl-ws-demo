module WSDemo.Client where

import Prelude

import Control.Coroutine as CR
import Control.Coroutine.Aff (emit)
import Control.Coroutine.Aff as CRA
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Halogen as H
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import Simple.JSON as SimpleJSON
import WsDemo.Display as D
import WsDemo.Socket (createSocket)

wsProducer :: CR.Producer String Aff Unit
wsProducer = CRA.produce \emitter -> do
  createSocket "ws://localhost:8082/ws" (emit emitter)

wsConsumer :: (D.Query ~> Aff) -> CR.Consumer String Aff Unit
wsConsumer query = CR.consumer \msg -> do
  case SimpleJSON.readJSON msg of
    Left _ ->
      liftEffect $ log $ "Couldn't decode message: " <> msg
    Right x -> 
      query $ H.action $ D.UpdateMessage x
  pure Nothing

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  io <- runUI D.statsDisplay unit body
  CR.runProcess (wsProducer CR.$$ wsConsumer io.query)
