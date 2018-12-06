module ModuleNames where

import Erl.ModuleName (ModuleName(..))


wsDemoServer :: ModuleName
wsDemoServer = ModuleName "WsDemo.Server"

wsDemoWS :: ModuleName
wsDemoWS = ModuleName "WsDemo.WS"

wsDemoCpu :: ModuleName
wsDemoCpu = ModuleName "WsDemo.Cpu"

moduleNames :: ModuleName
moduleNames = ModuleName "ModuleNames"
