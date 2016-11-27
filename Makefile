VERSION="0.1.0"
BUILD=`date +%FT%T%z`

LDFLAGS=-ldflags "-X main.Version=${VERSION} -X main.Build=${BUILD}"

build:
	echo ${BUILD}
	cd src/github.com/krogebry/workout_tracker
	go build ${LDFLAGS} 


