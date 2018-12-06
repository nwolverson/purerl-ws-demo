-module(wsDemo_wS@foreign).
-export([startInterval/2]).

startInterval(TimeMs, Msg) -> fun () ->
    timer:send_interval(TimeMs, Msg)
end.