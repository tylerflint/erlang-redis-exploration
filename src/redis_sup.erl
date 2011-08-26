
-module(redis_sup).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

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
        {redis_db, {redis_db, start_link, []}, permanent, 2000, worker, [redis_db]}
    ]}}.

