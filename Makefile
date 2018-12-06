.PHONY: all ps clean erl bundle

all: ps bundle erl

ps:
	$(MAKE) -C server ps
	$(MAKE) -C client ps
	$(MAKE) -C spork-client ps

bundle:
	$(MAKE) -C client bundle
	$(MAKE) -C spork-client bundle
	cp client/bundle.js priv/index.js
	cp spork-client/bundle.js priv/spork.js

clean:
	$(MAKE) -C client clean
	$(MAKE) -C server clean
	$(MAKE) -C spork-client clean

erl:
	$(MAKE) -C server erl
