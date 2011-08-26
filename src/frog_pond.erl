-module(frog_pond).

-export([
    add_frog/2,
    remove_frog/1,
    list_frogs/0,
    add_local_frog/2,
    remove_local_frog/1,
	test/0
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
	ets:insert(frog, #frog{name=string:to_lower(Name), color=Color}).

remove_local_frog(Name) ->
	ets:delete(frog,Name).

new_frog(Name,Color) ->
	#frog{name=string:to_lower(Name),color=Color}.
	
test() ->
	add_frog("Kermit","Green"),
	remove_frog("kermit"),
	list_frogs().
