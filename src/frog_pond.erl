-module(frog_pond).

-export([
    add_frog/2,
    remove_frog/1,
    list_frogs/0
]).

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
    ok.


