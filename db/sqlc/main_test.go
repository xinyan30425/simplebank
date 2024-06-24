package db

import (
	"database/sql"
	"log"
	"os"
	"testing"

	_ "github.com/techschool/simplebank/util"

	_ "github.com/lib/pq"
)

const (
	dbDriver = "postgres"
	dbSource = "postgresql://root:mysecretpassword@localhost:5433/simple_bank?sslmode=disable"
)

var testQueries *Queries
var testDB *sql.DB
var store *Store

func TestMain(m *testing.M) {
	var err error
	testDB, err = sql.Open(dbDriver, dbSource)
	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}

	testQueries = New(testDB)
	store = NewStore(testDB) // Initialize the store variable

	code := m.Run()

	os.Exit(code)
}
