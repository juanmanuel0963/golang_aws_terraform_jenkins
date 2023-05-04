package controllers

import (
	"errors"
	"fmt"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	uuid "github.com/satori/go.uuid"
)

type User struct {
	Id       string `json:"id"`
	Username string `json:"username"`
	Email    string `json:"email"`
}

func CreateUser(c *gin.Context) {
	var user User

	// Bind incoming JSON to user struct
	if err := c.ShouldBindJSON(&user); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Create a channel to communicate with the goroutine
	userChannel := make(chan User)
	errChannel := make(chan error)

	//Calling Go routine
	go createUser(user, userChannel, errChannel)

	// Wait for the user to be created and sent through the channel
	select {
	case theUser := <-userChannel:
		c.JSON(http.StatusOK, gin.H{
			"user": theUser,
		})
	case err := <-errChannel:
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
	}
}

func createUser(theUser User, userChannel chan<- User, errChannel chan<- error) {
	// Simulate a database insert by sleeping
	time.Sleep(1 * time.Second)

	// Generate a UUID for the new user
	uuid := uuid.NewV4()
	theUser.Id = uuid.String()

	// Simulate a database query
	users := []User{
		{Id: "1", Username: "John Doe", Email: "john@example.com"},
		{Id: "2", Username: "Jane Doe", Email: "jane@example.com"},
		{Id: "3", Username: "Bob Smith", Email: "bob@example.com"},
	}

	// Append the created user to the users slice
	users = append(users, theUser)

	fmt.Println(users)

	// Return an error if the user ID is empty
	if theUser.Id == "" {
		errChannel <- errors.New("failed to create user")
	} else {
		// Send the created user through the channel
		userChannel <- theUser
	}

	close(userChannel)
	close(errChannel)
	fmt.Println("closed")
}
