.PHONY: all test build

all: test build

test:
	@ test/test.sh

build: build/multipass.sh

build/multipass.sh: bin/multipass.sh tools/build.sh lib/*.sh lib/*/*.sh lib/*/*/*.sh
	tools/build.sh $< $@

clean:
	rm -Rf build
