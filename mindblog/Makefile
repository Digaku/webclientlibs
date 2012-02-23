
BUILDTOOLS=../buildtools
CLOSURE_ROOTDIR=../lib/closure

CLOSURE_COMPILER=$(BUILDTOOLS)/closure-compiler.jar
SOY_COMPILER=$(BUILDTOOLS)/SoyToJsSrcCompiler.jar
CLOSURE_BUILDER=$(CLOSURE_ROOTDIR)/closure/bin/build/closurebuilder.py

TMP=/tmp/mindblog-23hile

all: dg.mindblog.js dg.mindblog.min.js


dev: dg.mindblog.js dg.mindblog.css

$(TMP)/dg.mindblog.js: src/dg.mindblog.coffee
	mkdir -p /tmp/mindblog
	coffee -c --bare -o $(TMP) $<

dg.mindblog.js: $(TMP)/dg.mindblog.js $(wildcard js/*.js)
	python $(CLOSURE_BUILDER) --root=$(CLOSURE_ROOTDIR) --root=$(TMP) --root=./js \
		--namespace="mt.ui" \
		--output_mode=compiled \
		--compiler_jar=$(CLOSURE_COMPILER) \
		--compiler_flags=--compilation_level=WHITESPACE_ONLY \
		| sed s/COMPILED=false/COMPILED=true/ > $(TMP)/$@.tmp && mv /$(TMP)/$@.tmp $@

dg.mindblog.min.js: $(TMP)/dg.mindblog.js $(wildcard js/*.js)
	python $(CLOSURE_BUILDER) --root=$(CLOSURE_ROOTDIR) --root=$(TMP) --root=./js \
		--namespace="mt.ui" \
		--output_mode=compiled \
		--compiler_jar=$(CLOSURE_COMPILER) \
		--compiler_flags=--output_wrapper="(function(){%output%}).call(this)" \
		--compiler_flags=--compilation_level=ADVANCED_OPTIMIZATIONS \
		> $@

dg.mindblog.css: $(wildcard css/*.less) $(wildcard css/bootstrap/lib/*.less)
	lessc $< > $@ 

watch:
	watchr watchr.rb

clean:
	rm -f *.min.js
	rm -f dg.mindblog.js
	rm -rf $(TMP)

.PHONY: all clean dev watch

