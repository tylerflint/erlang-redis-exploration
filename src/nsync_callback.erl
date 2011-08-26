-module(nsync_callback).


-export([handle/1]).

handle({load, Key, Val}) ->
    % io:format("Key:~s Value:~w~n", [Key, Val]);
    ok;

handle({load, eof}) ->
    % io:format("redis tables loaded.", []);
    ok;

handle({cmd, Cmd, Args}) ->
    % io:format("Cmd: ~s Args: ~s~n", [Cmd, Args]);
    ok;

handle({error, closed}) ->
    % io:format("Error NSYNC connection closed. Read-only mode enabled"),
    ok;

handle(_) ->
    ok.

