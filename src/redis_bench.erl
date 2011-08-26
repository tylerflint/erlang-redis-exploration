-module(redis_bench).

-export([test/1]).

test(Max) ->
    A = now(),
    loop(0, Max),
    B = now(),
    io:format("benchmark duration=~w~n", [timer:now_diff(B,A) div 1000000]).
    

loop(CurrentIterator, Max) when CurrentIterator == Max ->
    ok;

loop(CurrentIterator, Max) ->
    add_frog(CurrentIterator),
    loop(CurrentIterator + 1, Max).

add_frog(CurrentIterator) ->
    frog_pond:add_frog(lists:append(["kermit.", integer_to_list(CurrentIterator)]), "green").


