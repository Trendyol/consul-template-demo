FROM golang:1.14 as build

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY . ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/main ./*.go

FROM alpine

COPY --from=build /app/main /app/main
WORKDIR /app

CMD ["./main"]
