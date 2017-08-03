all: push

BUILDTAGS=
APP?=test-k8s-app
USERSPACE?=maxim0r

RELEASE?=0.1.0
PROJECT?=github.com/${USERSPACE}/${APP}
REPO_INFO=$(shell git config --get remote.origin.url)

GOOS?=linux


vendor: clean
	go get -u github.com/Masterminds/glide \
	&& glide install

build: vendor
	CGO_ENABLED=0 GOOS=${GOOS} go build -a -installsuffix cgo \
		-ldflags "-s -w -X ${PROJECT}/version.RELEASE=${RELEASE} -X ${PROJECT}/version.COMMIT=${COMMIT} -X ${PROJECT}/version.REPO=${REPO_INFO}" \
		-o ${APP}

clean:
	rm -f ${APP}