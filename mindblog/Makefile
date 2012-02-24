
BUILDTOOLS=../buildtools
CLOSURE_ROOTDIR=../lib/closure

CLOSURE_COMPILER=$(BUILDTOOLS)/closure-compiler.jar
SOY_COMPILER=$(BUILDTOOLS)/SoyToJsSrcCompiler.jar
CLOSURE_BUILDER=$(CLOSURE_ROOTDIR)/closure/bin/build/closurebuilder.py
YUI_COMPRESSOR=$(BUILDTOOLS)/yuicompressor-2.4.5.jar

VERSION=0.0.1
TMP=/tmp/mindblog-$(VERSION)

all: dg.mindblog.js dg.mindblog-$(VERSION).min.js deploy


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
		> $(TMP)/$@.tmp && \
		cp $(TMP)/$@.tmp $@

dg.mindblog-$(VERSION).min.js: dg.mindblog.min.js
	sed 's/\$$VERSION\$$/0.0.1/g' dg.mindblog.min.js > $@
	cp dg.mindblog-$(VERSION).min.js dg.mindblog-latest.min.js

dg.mindblog.css: $(wildcard css/*.less) $(wildcard css/bootstrap/lib/*.less)
	lessc $< > $@ 

dg.mindblog-$(VERSION).min.css: dg.mindblog.css
	java -jar $(YUI_COMPRESSOR) --nomunge $< -o $@

dg.mindblog-latest.min.css: dg.mindblog-$(VERSION).min.css
	rm -f $@
	cp $< $@

watch:
	watchr watchr.rb

deploy: dg.mindblog-$(VERSION).min.js README.md dg.mindblog-$(VERSION).min.css dg.mindblog-latest.min.css index_example.html
	zip mindtalk-blog-$(VERSION).zip $^
	zip mindtalk-blog-latest.zip $^

update: deploy
	rsync -avzrh --progress --rsh='ssh -p771' \
	 	*.zip dg.mindblog-*.min.js dg.mindblog-*.min.css \
		anvie@immortall:~/www/mindblog/

clean:
	rm -f *.min.js
	rm -f dg.mindblog.js
	rm -rf $(TMP)
	rm -rf *.zip

.PHONY: all clean dev watch version deploy

