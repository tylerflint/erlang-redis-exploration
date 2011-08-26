-module(redis_db).

-export([start_link/0]).

-include_lib("redis.hrl").


start_link() ->
    create_ets_tables(),
    {ok, Pid} = redo:start_link(config),
    boot_nsync(),
    {ok, Pid}.

create_ets_tables() ->
	ets:new(frog, [named_table,set,public, {keypos, 2}]).

boot_nsync() ->
    ok = application:start(nsync, temporary),
    Opts = nsync_opts(),
    % io:format("nsync:start_link(~p)~n", [Opts]),
    A = now(),
    {ok, _Pid} = nsync:start_link(Opts),
    B = now().
    % io:format("nsync load_time=~w~n", [timer:now_diff(B,A) div 1000000]).

nsync_opts() ->
    [{callback, {nsync_callback, handle, []}}, {block, false}, {timeout, 20 * 60 * 1000}].
