-module(nsync_callback).


-export([handle/1]).

handle({load, Key, Val}) ->
    io:format("Key:~s Value:~s~n", [Key, Val]);

handle({load, eof}) ->
    io:format("redis tables loaded.", []);

handle({cmd, Cmd, Args}) ->
    io:format("Cmd: ~s Args: ~s~n", [Cmd, Args]);

handle({error, closed}) ->
    io:format("Error NSYNC connection closed. Read-only mode enabled"),
    ok;

handle(_) ->
    ok.

