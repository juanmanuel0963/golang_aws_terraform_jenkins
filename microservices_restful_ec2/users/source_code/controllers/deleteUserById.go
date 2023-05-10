package controllers

import (
	"errors"
	"fmt"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

// DeleteUserByID handles DELETE requests for deleting a specific user by ID
func DeleteUserById(c *gin.Context) {

	// Get user ID from path parameter
	userId, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Invalid your user ID",
		})
		return
	}

	// Create a channel to communicate with the goroutine
	userChannel := make(chan BodyUser)
	errChannel := make(chan error)

	//Calling Go routine
	go deleteUserInDatabase(userId, userChannel, errChannel)

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

func deleteUserInDatabase(userId int, userChannel chan<- BodyUser, errChannel chan<- error) {

	// Simulate a database select by sleeping
	time.Sleep(1 * time.Second)

	// Simulate a database query
	users := []BodyUser{
		{Id: "1", Name: "John Doe", Age: 20},
		{Id: "2", Name: "Jane Doe", Age: 30},
		{Id: "3", Name: "Bob Smith", Age: 40},
	}
	/*
		users := []User{
			{Id: "1", Name: "John Doe", Email: "john@example.com", Age: 20},
			{Id: "2", Name: "Jane Doe", Email: "jane@example.com", Age: 30},
			{Id: "3", Name: "Bob Smith", Email: "bob@example.com", Age: 40},
		}
	*/

	var theUser BodyUser

	// Search for user in slice
	for i, user := range users {

		sId := strconv.Itoa(userId)

		if user.Id == sId {
			fmt.Println(i)
			fmt.Println(user.Id)
			fmt.Println(user.Name)
			//fmt.Println(user.Email)

			users = append(users[:i], users[i+1:]...)
			//
			theUser = user
		}
	}

	fmt.Println(theUser)
	fmt.Println(users)

	// Return an error if the user ID is empty
	if theUser.Id == "" {
		errChannel <- errors.New("failed to find user deletion")
	} else {
		// Send the found user through the channel
		userChannel <- theUser
	}

	close(userChannel)
	close(errChannel)
	fmt.Println("closed")
}
