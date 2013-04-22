REBAR=`which rebar || which ./rebar`
DIALYZER=`which dialyzer`
ERL=`which erl`

all: deps compile

deps:
	@$(REBAR) get-deps

compile: deps
	@$(REBAR) compile

app.plt:
	@$(DIALYZER) --build_plt --output_plt app.plt --apps erts kernel stdlib

dialyze: app.plt compile
	@$(DIALYZER) -q --plt app.plt -n apps/**/ebin -Wunmatched_returns \
		-Werror_handling -Wrace_conditions -Wunderspecs

test:
	@$(REBAR) skip_deps=true eunit

validate: dialyze test

clean:
	@$(REBAR) clean

release: clean validate
	@$(REBAR) generate

node:
	./rel/boilerman/bin/boilerman stop &> /dev/null || true
	./rel/boilerman/bin/boilerman start &> /dev/null || true
	@sleep 1

repl: node
	erl -name dev_boilerman_repl -setcookie boilerman -remsh boilerman@127.0.0.1

.PHONY: all test clean validate dialyze deps
