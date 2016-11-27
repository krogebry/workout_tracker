BINARY=wt-api

VERSION="0.1.0"
BUILD_TIME=`date +%FT%T%z`

LDFLAGS=-ldflags "-X main.Version=${VERSION} -X main.BuildTime=${BUILD_TIME}"

deps:
	cd src/github.com/krogebry/workout_tracker/
	go get 

build:
	go build ${LDFLAGS} -o bin/${BINARY} src/github.com/krogebry/workout_tracker/*.go

clean:
	if [ -f bin/${BINARY} ] ; then rm bin/${BINARY} ; fi

