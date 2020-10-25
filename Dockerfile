FROM golang:1.13-buster as builder
RUN mkdir /build 
ADD . /build/
WORKDIR /build 
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o main ./cmd/main.go
FROM gcr.io/distroless/base-debian10
COPY --from=builder /build/main /app/
COPY --from=builder /build/templates /app/templates
WORKDIR /app
CMD ["./main"]