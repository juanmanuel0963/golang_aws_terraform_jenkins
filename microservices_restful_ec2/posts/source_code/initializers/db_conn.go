package initializers

import (
	"fmt"
	"log"
	"os"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB

func ConnectToDB() {

	var err error
	dsn := os.Getenv("db_conn")
	myDB, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	DB = myDB

	if err != nil {
		log.Fatal("Failed to connect to database")
	} else {
		fmt.Println("Connected successfully to database")
	}

}
