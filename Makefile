all: 
	(cd deps/redo;$(MAKE) all)
	@./rebar compile
	@escript release/build_rel.escript boot redis `pwd`/ebin

clean:
	rm -f ebin/*.beam erl_crash.dump release/*.boot

clean_all: clean
	(cd deps/redo;$(MAKE) clean)

