module WsDemo.Server where

import Prelude

import Cowboy.Static as CowboyStatic
import Effect (Effect)
import Effect.Console (log)
import Effect.Uncurried (EffectFn2, mkEffectFn2)
import Erl.Atom (Atom, atom)
import Erl.Cowboy (ProtoEnv(..), ProtoOpt(..), TransOpt(..), env, protocolOpts, startClear)
import Erl.Cowboy.Routes as Routes
import Erl.Data.List (nil, singleton, (:))
import Erl.Data.Tuple (Tuple2, tuple4)
import Erl.ModuleName (nativeModuleName)
import Erl.Process.Raw (Pid)
import Foreign (unsafeToForeign)
import ModuleNames as Modules

foreign import startLink :: Effect (Tuple2 Atom Pid)

start :: forall a b. EffectFn2 a b (Tuple2 Atom Pid)
start = mkEffectFn2 \_ _ -> do
  let paths = (Routes.path "/ws/[...]" (nativeModuleName Modules.wsDemoWS) (Routes.InitialState $ unsafeToForeign nil))
            : (CowboyStatic.file "/index.js" "/index.js")
            : (CowboyStatic.file "/" "/index.html")
            : (CowboyStatic.file "/spork.js" "/spork.js")
            : (CowboyStatic.file "/spork.html" "/spork.html")
            : nil
      dispatch = Routes.compile $ singleton $ Routes.anyHost paths
      transOpts = Ip (tuple4 0 0 0 0) : Port 8082 : nil
      protoOpts = protocolOpts $ Env (env (Dispatch dispatch : nil)) : nil
  res <- startLink
  _ <- startClear (atom "http_listener") transOpts protoOpts
  log "Started HTTP listener on port 8082. Try a WS connection to /ws"
  pure res
