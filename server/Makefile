.PHONY: all ps ide ps-deps install clean erl

PS_SRC = src
COMPILED_PS = ../src/compiled_ps
OUTPUT = output
GEN_MODULES = $(shell ls .psc-package/$$(jq '.set' psc-package.json -r)/erl-modules/*/scripts/gen_module_names.sh)

all: ps erl

ide:
	psc-package sources | xargs purs compile '$(PS_SRC)/**/*.purs' '../shared/**/*.purs' --json-errors

ps:
	$(GEN_MODULES)
	psc-package sources | xargs purs compile '$(PS_SRC)/**/*.purs' '../shared/**/*.purs'

# Useful to update externs if sources won't compile
ps-deps:
	psc-package sources | xargs purs compile

clean:
	rm -rf $(OUTPUT)/*
	rm -f $(COMPILED_PS)/*

install:
	psc-package install

erl:
	mkdir -p $(COMPILED_PS)
	cp -pu $(OUTPUT)/*/*.erl $(COMPILED_PS)/
