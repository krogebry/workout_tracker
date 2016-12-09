BINARY=wt-api

VERSION="0.2.0"
BUILD_TIME=`date +%FT%T%z`

LDFLAGS=-ldflags "-X main.Version=${VERSION} -X main.BuildTime=${BUILD_TIME}"

clean_up: | clean build dc_build dc_up

dc_build:
	docker-compose build

dc_up:
	docker-compose up

deps:
	#go get gopkg.in/mgo.v2
	go get github.com/go-sql-driver/mysql
	go get github.com/Sirupsen/logrus
	#cd src/github.com/krogebry/workout_tracker/
	#PWD="${HOME}/dev/workout_tracker/src/github.com/krogebry/workout_tracker/" go get 

build:
	go build ${LDFLAGS} -o bin/${BINARY} src/github.com/krogebry/workout_tracker/*.go

push:
	docker tag wt-api:${VERSION} krogebry/wt-api:latest
	docker push krogebry/wt-api

docker_image:
	docker build -t wt-api:${VERSION} -f docker/wt-api .

clean:
	if [ -f bin/${BINARY} ] ; then rm bin/${BINARY} ; fi

create_db_vol:
	docker volume create --name=database

docker_cleanup:
	# Kill all running containers.
	#docker kill $(docker ps -q)
	# Delete all stopped containers.
	#docker rm $(docker ps -a -q)
	# Delete all untagged images.
	#docker rmi $(docker images -q -f dangling=true)
