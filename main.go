// main.go
package main

import (
	"database/sql"
	"fmt"
	"log"

	"github.com/xinyan30425/simplebank/util"

	_ "github.com/lib/pq"
	"github.com/xinyan30425/simplebank/api"
	db "github.com/xinyan30425/simplebank/db/sqlc"
)

func main() {
	config, err := util.LoadConfig(".")
	if err != nil {
		log.Fatal("cannot load config:", err)
	}

	fmt.Printf("Loaded Config: %+v\n", config) // Debug print

	if config.DBDriver == "" {
		log.Fatal("DB_DRIVER is not set")
	}

	conn, err := sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}

	if err = conn.Ping(); err != nil { // Check if the database is connected
		log.Fatal("cannot ping to db:", err)
	}

	store := db.NewStore(conn)
	server := api.NewServer(store)

	fmt.Printf("Starting server at %s\n", config.ServerAddress) // Debug print

	err = server.Start(config.ServerAddress)
	if err != nil {
		log.Fatal("cannot start server:", err)
	}
}
