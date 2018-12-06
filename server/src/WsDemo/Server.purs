module WsDemo.Server where

import Prelude hiding (mod)

import Effect (Effect)
import Effect.Uncurried (EffectFn2, mkEffectFn2)
import Effect.Console (log)
import Erl.Atom (Atom, atom)
import Erl.Cowboy (ProtoEnv(..), ProtoOpt(..), TransOpt(..), env, protocolOpts, startClear)
import Erl.Cowboy.Routes (compile, mod, Module)
import Erl.Data.List (nil, singleton, (:))
import Erl.Data.Tuple (Tuple2, tuple2, tuple3, tuple4, Tuple3)
import Erl.Process.Raw (Pid)
import Foreign (unsafeToForeign, Foreign)

foreign import startLink :: Effect (Tuple2 Atom Pid)

static :: String -> String -> Tuple3 String Module Foreign
static url file = tuple3 url (mod "cowboy_static") (unsafeToForeign $ tuple3 (atom "priv_file") (atom "wsdemo") file)

start :: forall a b. EffectFn2 a b (Tuple2 Atom Pid)
start = mkEffectFn2 \_ _ -> do
  let paths = (tuple3 "/ws/[...]" (mod "wsDemo_wS@ps") (unsafeToForeign 0))
            : (static "/index.js" "/index.js")
            : (static "/" "/index.html")
            : (static "/spork.js" "/spork.js")
            : (static "/spork.html" "/spork.html")
            : nil
      routes = singleton (tuple2 (atom "_") paths)
      dispatch = compile routes
      transOpts = Ip (tuple4 0 0 0 0) : Port 8082 : nil
      protoOpts = protocolOpts $ Env (env (Dispatch dispatch : nil)) : nil
  res <- startLink
  _ <- startClear (atom "http_listener") transOpts protoOpts
  log "Started HTTP listener on port 8082. Try a WS connection to /ws"
  pure res
