.PHONY: all test

all: test

test:
	lua test/test_bytebuf.lua
	lua test/test_ssebin.lua
