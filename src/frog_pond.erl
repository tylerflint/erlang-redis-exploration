-module(frog_pond).

-export([
    add_frog/2,
    remove_frog/1,
    list_frogs/0
]).

add_frog(Name, Color) ->
    %% create the unique frog id
    % FrogId = redo:cmd(["INCR", "next.frog.id"]),
    % Key = "frog:" ++ integer_to_list(FrogId), 
    Key = "frog:" ++ Name,

    %% store the frog
    redo:cmd(["HMSET", Key, 
        "name", Name,
        "color", Color
    ]),

    %% add the frog id to the frog list
    redo:cmd(["SADD", "frogs", Key]).

remove_frog(Name) ->
    ok.

list_frogs() ->
    ok.


