-module(frog_pond).

-export([
    add_frog/2,
    remove_frog/1,
    list_frogs/0,
    add_local_frog/2,
    remove_local_frog/1
]).

-include_lib("redis.hrl").


add_frog(Name, Color) ->
    Key = iolist_to_binary(["frog:", string:to_lower(Name), ":data"]),
    redo:cmd(["HMSET", Key, 
        "name", Name,
        "color", Color
    ]).

remove_frog(Name) ->
    Key = iolist_to_binary(["frog:", string:to_lower(Name), ":data"]),
    redo:cmd(["DEL", Key]).

list_frogs() ->
	ets:match(frog,'$1').

add_local_frog(Name, Color) ->
	ets:insert(frog, #frog{name=Name, color=Color}).

remove_local_frog(Name) ->
	ets:match_delete(frog,{Name,'_'}).

new_frog(Name,Color) ->
	#frog{name=Name,color=Color}.
