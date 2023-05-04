package controllers

import (
	"errors"
	"fmt"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

// GetAllUsers retrieves all users
func GetAllUsers(c *gin.Context) {

	// Create a channel to communicate with the goroutine
	usersChannel := make(chan []User)
	errChannel := make(chan error)

	//Calling Go routine
	go getAllUserFromDatabase(usersChannel, errChannel)

	// Wait for the user to be created and sent through the channel
	select {
	case theUsers := <-usersChannel:
		c.JSON(http.StatusOK, gin.H{
			"users": theUsers,
		})
	case err := <-errChannel:
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
	}
}

func getAllUserFromDatabase(usersChannel chan<- []User, errChannel chan<- error) {

	// Simulate a database select by sleeping
	time.Sleep(1 * time.Second)

	// Simulate a database query
	users := []User{
		{Id: "1", Username: "John Doe", Email: "john@example.com"},
		{Id: "2", Username: "Jane Doe", Email: "jane@example.com"},
		{Id: "3", Username: "Bob Smith", Email: "bob@example.com"},
	}

	fmt.Println(users)

	// Return an error if the user ID is empty
	if len(users) == 0 {
		errChannel <- errors.New("failed to find users")
	} else {
		// Send the found user through the channel
		usersChannel <- users
	}

	close(usersChannel)
	close(errChannel)
	fmt.Println("closed")
}
