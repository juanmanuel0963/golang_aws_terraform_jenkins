package controllers

import (
	"errors"
	"fmt"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

func GetUserById(c *gin.Context) {
	// Get user ID from path parameter
	userId, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Invalid user ID",
		})
		return
	}

	// Create a channel to communicate with the goroutine
	userChannel := make(chan User)
	errChannel := make(chan error)

	//Calling Go routine
	go getUserFromDatabase(userId, userChannel, errChannel)

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

func getUserFromDatabase(userId int, userChannel chan<- User, errChannel chan<- error) {

	// Simulate a database select by sleeping
	time.Sleep(1 * time.Second)

	// Simulate a database query
	users := []User{
		{Id: "1", Username: "John Doe", Email: "john@example.com"},
		{Id: "2", Username: "Jane Doe", Email: "jane@example.com"},
		{Id: "3", Username: "Bob Smith", Email: "bob@example.com"},
	}

	var theUser User

	// Search for user in slice
	for i, user := range users {

		sId := strconv.Itoa(userId)

		if user.Id == sId {
			fmt.Println(i)
			fmt.Println(user.Id)
			fmt.Println(user.Username)
			fmt.Println(user.Email)
			theUser = user
		}
	}

	fmt.Println(theUser)

	// Return an error if the user ID is empty
	if theUser.Id == "" {
		errChannel <- errors.New("failed to find user")
	} else {
		// Send the found user through the channel
		userChannel <- theUser
	}

	close(userChannel)
	close(errChannel)
	fmt.Println("closed")
}
