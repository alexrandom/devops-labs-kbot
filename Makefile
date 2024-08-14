APP=$(shell basename $(shell git remote get-url origin))
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
REGISTRY=alexrandom
TARGETOS=linux #windows linux darwin
TARGETARC=amd64 #arm64 amd64 x86_64

format:
	gofmt -s -w ./

get:
	go get

lint:
	golint

test:
	go test -v

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARC} go build -v -o kbot -ldflags "-X="devops-labs-bot/cmd.appVersion=${VERSION}

linux: TARGETOS=linux
linux: TARGETARC=amd64
linux: build
linux: image

mac: TARGETOS=darwin
mac: TARGETARC=amd64
mac: build
mac: image

arm: TARGETOS=linux
arm: TARGETARC=arm
arm: build
arm: image

windows: TARGETOS=windows
windows: TARGETARC=amd64
windows: build
windows: image

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-$(TARGETARC)

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-$(TARGETARC)

clean:
	rm -rf kbot
	docker rmi -f ${REGISTRY}/${APP}:${VERSION}-$(TARGETARC)