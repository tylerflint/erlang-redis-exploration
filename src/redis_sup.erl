
-module(redis_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1,nsync_opts/0]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok, { {one_for_one, 5, 10}, [
        {redo, {redo, start_link, []}, permanent, 2000, worker, [redo]},
        {redgrid, {redgrid, start_link, []}, permanent, 2000, worker, [redgrid]},
        {nsync, {nsync, start_link, [nsync_opts()]}, permanent, 2000, worker, [nsync]}
    ]}}.

nsync_opts() ->
    [{callback, {nsync_callback, handle, []}}, {block, false}, {timeout, 20 * 60 * 1000}].
