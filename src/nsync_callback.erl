-module(nsync_callback).


-export([handle/1]).

handle({load, Key, Val}) ->
	%some times Val has the value {dict,_,_,_,_,_,_,_,_}, this will not work will the ~s formatter
    io:format("mine Key:~s Value:~w~n", [Key, Val]);
	
handle({load, eof}) ->
    io:format("redis tables loaded.", []);

handle({cmd, Cmd, Args}) ->
    io:format("Cmd: ~s Args: ~s~n", [Cmd, Args]);

handle({error, closed}) ->
    io:format("Error NSYNC connection closed. Read-only mode enabled"),
    ok;

handle(_) ->
    ok.