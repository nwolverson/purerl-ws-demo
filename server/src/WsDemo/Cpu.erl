-module(wsDemo_cpu@foreign).
-export([avg1_/2, avg5_/2, avg15_/2]).

avg1_(Nothing, Just) -> fun () ->
    case cpu_sup:avg1() of
        {error, _} -> Nothing;
        Load when is_integer(Load) -> Just(Load)
    end
end.

avg5_(Nothing, Just) -> fun () ->
    case cpu_sup:avg5() of
        {error, _} -> Nothing;
        Load when is_integer(Load) -> Just(Load)
    end
end.

avg15_(Nothing, Just) -> fun () ->
    case cpu_sup:avg15() of
        {error, _} -> Nothing;
        Load when is_integer(Load) -> Just(Load)
    end
end.