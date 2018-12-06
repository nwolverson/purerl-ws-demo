.PHONY: all ps ps-deps install ide clean bundle

PS_SRC = src
COMPILED_PS = ../src/compiled_ps
OUTPUT = output

all: bundle

ide:
	psc-package sources | xargs purs compile --codegen js '$(PS_SRC)/**/*.purs' '../shared/**/*.purs' --json-errors

ps:
	psc-package sources | xargs purs compile --codegen js '$(PS_SRC)/**/*.purs' '../shared/**/*.purs'

bundle: ps
	purs bundle 'output/**/*.js' -o bundle.js -m 'WSDemo.Client' --main 'WSDemo.Client'

# Useful to update externs if sources won't compile
ps-deps:
	psc-package sources | xargs purs compile --codegen js

clean:
	rm -rf $(OUTPUT)/*
	rm -f $(COMPILED_PS)/*

install:
	psc-package install

