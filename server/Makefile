.PHONY: all ps ide ps-deps install clean erl

PS_SRC = src
COMPILED_PS = ../src/compiled_ps
OUTPUT = output

all: ps erl

ide:
	psc-package sources | xargs purs compile '$(PS_SRC)/**/*.purs' '../shared/**/*.purs' --json-errors

ps:
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
