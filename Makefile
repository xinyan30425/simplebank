postgres:
	docker run --name postgres12 -p 5433:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=mysecretpassword -d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://postgres:M%5BaN%5Bh-%7DDm5%25%7B%25mm%24%3CpS%3Cg%3FG%7E%2490@mypostgresdatabase.c902c28air56.us-east-1.rds.amazonaws.com:5432/postgres" --verbose up

migrateup1:
	migrate -path db/migration -database "postgresql://root:mysecretpassword@localhost:5433/simple_bank?sslmode=disable" --verbose up 1


migratedown:
	migrate -path db/migration -database "postgresql://root:mysecretpassword@localhost:5433/simple_bank?sslmode=disable" --verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://root:mysecretpassword@localhost:5433/simple_bank?sslmode=disable" --verbose down 1


migrateforce:
	migrate -path db/migration -database "postgresql://root:mysecretpassword@localhost:5433/simple_bank?sslmode=disable" force 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go
# mock:
# 	mockgen -package mockdb -destination db/mock/store.go github.com/alexander-lemke
mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/xinyan30425/simplebank/db/sqlc Store


.PHONY: postgres createdb dropdb migrateup migratedown migrateforce sqlc test server mock
