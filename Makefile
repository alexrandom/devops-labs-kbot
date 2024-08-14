APP=$(shell basename $(shell git remote get-url origin))
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
REGISTRY=alexrandom
TARGETOS=linux #windows linux darwin
TARGETARC=amd64 #arm64 amd64

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
image: build
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-$(TARGETARC)
push:
	docker push ${REGISTRY}/${APP}:${VERSION}-$(TARGETARC)
clean:
	rm -rf kbot