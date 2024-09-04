DB_URL = postgresql://root:mysecretpassword@localhost:5433/simple_bank?sslmode=disable

postgres:
	docker run --name postgres12 -p 5433:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=mysecretpassword -d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

# migrateup:
# 	migrate -path db/migration -database "postgresql://postgres:vvedJNjZVNFbMw9YPk0k@simple-bank.ctumycw607zt.us-east-2.rds.amazonaws.com/postgres" --verbose up 1


# migrateup1:
# 	migrate -path db/migration -database "postgresql://root:mysecretpassword@localhost:5433/simple_bank?sslmode=disable" --verbose up

# migratedown:
# 	migrate -path db/migration -database "postgresql://root:mysecretpassword@localhost:5433/simple_bank?sslmode=disable" --verbose down

# migratedown1:
# 	migrate -path db/migration -database "postgresql://root:mysecretpassword@localhost:5433/simple_bank?sslmode=disable" --verbose down 1

migrateup:
	migrate -path db/migration -database "$(DB_URL)" --verbose up 1


migrateup1:
	migrate -path db/migration -database "$(DB_URL)" --verbose up

migratedown:
	migrate -path db/migration -database "$(DB_URL)" --verbose down

migratedown1:
	migrate -path db/migration -database "$(DB_URL)" --verbose down 1


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

db_docs:
	dbdocs build doc/db.dbml

db_schema:
	dbml2sql --postgres -o doc/schema.sql doc/db.dbml



.PHONY: postgres createdb dropdb migrateup migratedown migrateforce sqlc test server mock db_docs db_schema
