all: 
	(cd deps/redo;$(MAKE) all)
	(cd deps/redgrid;$(MAKE) all)
	(cd deps/nsync;$(MAKE) all)
	@./rebar compile
	@escript release/build_rel.escript boot redis `pwd`/ebin

clean:
	rm -f ebin/*.beam erl_crash.dump release/*.boot

clean_all: clean
	(cd deps/redo;$(MAKE) clean)
	(cd deps/redgrid;$(MAKE) clean)
	(cd deps/nsync;$(MAKE) clean)

