package db

import (
	"database/sql"
	"log"
	"os"
	"testing"

	"github.com/xinyan30425/simplebank/util"

	_ "github.com/lib/pq"
)

const (
	dbDriver = "postgres"
	dbSource = "postgresql://root:mysecretpassword@localhost:5433/simple_bank?sslmode=disable"
)

var testQueries *Queries
var testDB *sql.DB
var store Store

func TestMain(m *testing.M) {
	config, err := util.LoadConfig("../..")
	if err != nil {
		log.Fatal("cannot load config", err)
	}

	// testDB, err = sql.Open(dbDriver, dbSource)
	// if err != nil {
	// 	log.Fatal("cannot connect to db:", err)
	// }
	testDB, err = sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}

	testQueries = New(testDB)
	store = NewStore(testDB) // Initialize the store variable

	code := m.Run()

	os.Exit(code)
}
