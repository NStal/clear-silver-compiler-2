MOCHA=mocha -b -R spec --compilers coffee:coffee-script
test:
	coffee ./test/test.coffee

#$(MOCHA) ./test/main-test.coffee

.PHONY: test

