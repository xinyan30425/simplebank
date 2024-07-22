# Build stage
FROM golang:1.23rc2-alpine3.20 AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go
RUN apk add curl
RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.17.1/migrate.linux-amd64.tar.gz | tar xvz

# Run stage
FROM alpine:3.20
WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/migrate ./migrate
COPY app.env .
COPY db/migration ./migration
COPY start.sh .
COPY wait-for-postgres.sh .

RUN apk --no-cache add postgresql-client
RUN chmod +x /app/wait-for-postgres.sh
RUN chmod +x /app/start.sh

EXPOSE 8080

ENTRYPOINT ["/app/wait-for-postgres.sh", "postgres", "/app/start.sh"]
CMD ["/app/main"]
