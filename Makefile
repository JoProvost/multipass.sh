.PHONY: all test

all: test multipass.sh

test:
	@ test/test.sh

multipass.sh: bin/multipass.sh tools/build.sh lib/*.sh lib/*/*.sh lib/*/*/*.sh
	tools/build.sh $< $@
