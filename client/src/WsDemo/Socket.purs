module WsDemo.Socket where

import Prelude

import Control.Monad.Except (runExcept)
import Data.Foldable (for_)
import Effect (Effect)
import Effect.Timer (setInterval)
import Foreign (readString)
import Web.Event.EventTarget as EET
import Web.Socket.Event.EventTypes as WSET
import Web.Socket.Event.MessageEvent as ME
import Web.Socket.WebSocket as WS

-- | Simple wrapper around WS creation and initiation, for the case of a socket with incoming string data
-- | and using a (user-level) ping every 10s
createSocket :: String -> (String -> Effect Unit) -> Effect Unit
createSocket url cb = do
  socket <- WS.create url []
  listener <- EET.eventListener \ev ->
    for_ (ME.fromEvent ev) \msgEvent ->
      for_ (runExcept $ readString $ ME.data_ msgEvent) cb
  EET.addEventListener WSET.onMessage listener false (WS.toEventTarget socket)
  void $ setInterval 10000 $ WS.sendString socket "pingy"