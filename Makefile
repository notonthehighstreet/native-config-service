ifeq "$(PLATFORM)" ""
PLATFORM := $(shell uname)
endif

ifeq "$(PLATFORM)" "Darwin"
BUILDCOMMAND := "cd src && swift build -Xcc -fblocks -Xswiftc -I/usr/local/include -Xlinker -L/usr/local/lib"
else
BUILDCOMMAND := "cd src && swift build -Xcc -fblocks -Xlinker -rpath -Xlinker .build/debug"
endif

fetch:
	cd src && \
	swift package fetch && \
	find Packages/ -type d -name Tests | xargs rm -rf
clean:
	@echo --- Invoking swift build --clean
	cd src && swift build --clean
build: clean fetch
	@echo --- Building package
	"$(BUILDCOMMAND)"
test: build
	@echo --- Running tests
	cd src && swift test
run: build
	@echo --- Starting server
	./src/.build/debug/configserviceApp ./src/Sources/configserviceApp/config.json
