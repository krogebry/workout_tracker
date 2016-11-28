BINARY=wt-api

VERSION="0.1.2"
BUILD_TIME=`date +%FT%T%z`

LDFLAGS=-ldflags "-X main.Version=${VERSION} -X main.BuildTime=${BUILD_TIME}"

clean_up: | clean build dc_build dc_up

dc_build:
	docker-compose build

dc_up:
	docker-compose up

deps:
	#cd src/github.com/krogebry/workout_tracker/
	PWD="${HOME}/dev/workout_tracker/src/github.com/krogebry/workout_tracker/" go get 

build:
	go build ${LDFLAGS} -o bin/${BINARY} src/github.com/krogebry/workout_tracker/*.go

docker_image:
	docker build -t wt-api:${VERSION} -f docker/wt-api .

clean:
	if [ -f bin/${BINARY} ] ; then rm bin/${BINARY} ; fi

