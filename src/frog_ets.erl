-module(frog_ets).

-export([
 init/0
,new_frog/2
,add_frog/1
,remove_frog/1
,list_frogs/0
,test/0
]).

-record(frog,{name,color}).

init() ->
	ets:new(frog , [named_table,set]).
	
new_frog(Name,Color) ->
	#frog{name=Name,color=Color}.
	
add_frog(#frog{name=Name,color=Color}) ->
	ets:insert(frog,{Name,Color}).

remove_frog(Name) ->
	ets:match_delete(frog,{Name,'_'}).
	
list_frogs()->
	ets:match(frog,'$1').
	
	
test() ->
	init(),
	add_frog(new_frog("kermit","green")),
	add_frog(new_frog("fred","orange")),
	remove_frog("fred"),
	list_frogs().

	