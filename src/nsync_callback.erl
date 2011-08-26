-module(nsync_callback).

-include_lib("redis.hrl").

-export([handle/1]).

%[{<<"name">>,<<"fred">>},{<<"color">>,<<"orange">>}]
handle({load, <<"frog:", Rest/binary>>, Dict}) when is_tuple(Dict) ->
    create_frog(Dict);

handle({load, Key, Val}) ->
	%some times Val has the value {dict,_,_,_,_,_,_,_,_}, this will not work will the ~s formatter
    io:format("Key:~s Value:~w~n", [Key, Val]),
    ok;
	
handle({load, eof}) ->
%    io:format("redis tables loaded.", []),
    ok;


%Cmd: hmset Args: frog:kermit:datanamekermitcolorgreen
%[<<"frog:kermit:data">>,<<"name">>,<<"kermit">>,<<"color">>,<<"green">>]

handle({cmd, "hmset", [Key,_,Name,_,Color] = Args}) ->
	io:format("received an insertion ~s~n",[Args]),
	frog_pond:add_local_frog(binary:bin_to_list(Name),Color),
	ok;

handle({cmd, "expire", [Key] = Args}) ->
	io:format("received an expiration ~s~n",[Args]),
	ok;

%this one may not match against anything that we need for the frogs,
handle({cmd, "publish", [Key] = Args}) ->
	io:format("received a publication ~s~n",[Args]),
	ok;

handle({cmd, "del", [<<"frog:",Key/binary>>]}) ->
%	io:format("received a deletion ~s~n",Key),
	case binary:match(Key,<<":data">>) of
		{End,_} ->
			io:format("match!~n"),
			Name = binary:bin_to_list(binary:part(Key,0,End)),
			io:format("trying key '~s'~n",[Name]),
			frog_pond:remove_local_frog(Name),
			ok;
		nomatch ->
			io:format("unable to match~n")
	end;

%this is a match for data we do not care about
handle({cmd, Cmd, Args}) ->
%    io:format("I don't know what I got~nCmd: ~s Args: ~s~n", [Cmd, Args]),
    ok;

handle({error, closed}) ->
    io:format("Error NSYNC connection closed. Read-only mode enabled"),
    ok;

handle(_) ->
    ok.



create_frog(Dict) ->
	Name = binary:bin_to_list(dict_find(<<"name">>, Dict)),
	Color = binary:bin_to_list(dict_find(<<"color">>, Dict)),

%	Frog = #frog{
%		 name = Name
%		,color = Color
%	},
	frog_pond:add_local_frog(Name,Color).

parse_id(Bin) ->
    parse_id(Bin, []).

parse_id(<<":", _/binary>>, Acc) ->
    lists:reverse(Acc);

parse_id(<<C, Rest/binary>>, Acc) ->
    parse_id(Rest, [C|Acc]).

dict_from_list(List) ->
    dict_from_list(List, dict:new()).

dict_from_list([], Dict) ->
    Dict;

dict_from_list([Key, Val | Rest], Dict) ->
    dict_from_list(Rest, dict:store(Key, Val, Dict)).

dict_find(Key, Dict) ->
    case dict:find(Key, Dict) of
        {ok, Val} -> Val;
        _ -> undefined
    end.