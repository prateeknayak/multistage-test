FROM golang:alpine AS build

RUN apk update --no-cache && apk add git
WORKDIR /app

ENV GO111MODULE=on

COPY go.mod .
COPY go.sum .

RUN go mod download

ADD ./ /app

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-w -extldflags "-static"' -o golang-test

FROM scratch

WORKDIR /app
COPY --from=build /app/golang-test /app

ENTRYPOINT ["/app/golang-test"]

EXPOSE 8000
