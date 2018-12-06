module WsDemo.WS where

import Debug.Trace
import Effect.Console
import Prelude
import WsDemo.Model

import Attribute (Attribute(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Uncurried (EffectFn2, mkEffectFn1, mkEffectFn2)
import Erl.Cowboy.Handlers.WebSocket (CallResult, CowboyWebsocketBehaviour, Frame(..), FrameHandler, InfoHandler, InitHandler, WSInitHandler, initResult, okResult, outFrame, replyResult)
import Erl.Data.List (singleton)
import Simple.JSON as SimpleJSON
import WsDemo.Cpu as CPU

_behaviour :: CowboyWebsocketBehaviour
_behaviour = cowboyWebsocketBehaviour { init, websocket_info, websocket_handle }

type State = Unit

data InfoMessage = Timer

foreign import startInterval :: forall a. Int -> a -> Effect Unit

init :: forall c. InitHandler c State
init = mkEffectFn2 \req _ -> do
  log "init"
  pure $ initResult unit req

websocket_init :: WSInitHandler State
websocket_init = mkEffectFn1 \s -> do
  log "ws_init"
  startInterval 100 Timer
  pure $ okResult s

websocket_handle :: forall f. FrameHandler f
websocket_handle = mkEffectFn2 \frame state -> do
  log "got frame"
  pure $ okResult state

type FixedInfoHandler a s = EffectFn2 a s (CallResult s)
websocket_info :: FixedInfoHandler InfoMessage State
websocket_info = mkEffectFn2 info1
  where
  info1 :: InfoMessage -> State -> Effect (CallResult Unit)
  info1 msg state = do
    avg1' <- CPU.avg1
    avg5' <- CPU.avg5
    avg15' <- CPU.avg15
    case avg1', avg5', avg15' of 
      Just avg1, Just avg5, Just avg15 -> do
        let msg :: Message
            msg = { load: { avg1, avg5, avg15 }}
        let outFrames = singleton $ outFrame $ TextFrame $ SimpleJSON.writeJSON msg
        pure $ replyResult state outFrames
      _, _, _ -> do
        log "Some issue fetching load info"
        pure $ okResult state