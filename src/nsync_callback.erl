-module(nsync_callback).


-export([handle/1]).

handle({load, Key, Val}) ->
	%some times Val has the value {dict,_,_,_,_,_,_,_,_}, this will not work will the ~s formatter
%    io:format("mine Key:~s Value:~w~n", [Key, Val]),
    ok;
	
handle({load, eof}) ->
%    io:format("redis tables loaded.", []),
    ok;


%Cmd: hmset Args: frog:kermit:datanamekermitcolorgreen
%[<<"frog:kermit:data">>,<<"name">>,<<"kermit">>,<<"color">>,<<"green">>]

handle({cmd, "hmset", [Key,_,Name,_,Color] = Args}) ->
	io:format("received an insertion ~s~n",[Args]),
	frog_pond:add_local_frog(Name,Color),
	ok;

handle({cmd, "expire", [Key] = Args}) ->
	io:format("received an expiration ~s~n",[Args]),
	ok;

%this one may not match against anything that we need for the frogs,
handle({cmd, "publish", [Key] = Args}) ->
	io:format("received a publication ~s~n",[Args]),
	ok;

handle({cmd, "del", [<<"frog:",Rest/binary]}) ->
	io:format("received a deletion ~w~n",Args),
	io:format(Args),
%	Result = binary:match(Key,<<":data">>),
%	Name = binary:part(Key,4,End),
%	io:format("trying key '~s'",[Name]),
%	frog_pond:remove_local_frog(key),
	ok;

%this is a match for data we do not care about
handle({cmd, Cmd, Args}) ->
    io:format("I don't know what I got~nCmd: ~s Args: ~s~n", [Cmd, Args]),
    ok;

handle({error, closed}) ->
    io:format("Error NSYNC connection closed. Read-only mode enabled"),
    ok;

handle(_) ->
    ok.
