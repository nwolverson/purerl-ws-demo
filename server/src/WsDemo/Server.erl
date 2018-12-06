-module(wsDemo_server@foreign).
-export([startLink/0]).

startLink() -> fun () -> wsdemo_sup:start_link() end.
