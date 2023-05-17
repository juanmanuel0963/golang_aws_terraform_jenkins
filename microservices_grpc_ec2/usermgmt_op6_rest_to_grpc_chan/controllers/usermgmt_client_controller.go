package controllers

import (
	"context"
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/cognito/auth_token/source_code/verify_token"
	pb "github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_grpc_ec2/usermgmt_op6_rest_to_grpc_chan/usermgmt"
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_restful_ec2/_database/models"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

type BodyUser struct {
	Id   string `json:"id"`
	Name string `json:"name"`
	Age  int32  `json:"age"`
}

func UserCreate(c *gin.Context) {

	if verify_token.VerifyToken(c) {

		var body BodyUser

		// Bind incoming JSON to user struct
		if err := c.ShouldBindJSON(&body); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		var newUser = models.User{Name: body.Name, Age: body.Age}

		conn, err := grpc.Dial(os.Getenv("server_address")+":40056", grpc.WithTransportCredentials(insecure.NewCredentials()))
		if err != nil {
			log.Fatalf("did not connect: %v", err)
		}

		defer conn.Close()

		client := pb.NewUserManagementClient(conn)

		// Create a context with a timeout of 60 seconds
		ctx, cancel := context.WithTimeout(context.Background(), 60*time.Second)
		defer cancel()

		//------------------------------

		userToCreate := &pb.NewUser{Name: newUser.Name, Age: newUser.Age}

		// Create a channel to communicate with the goroutine
		userChannel := make(chan *pb.User)
		userErrChannel := make(chan error)

		//Calling Go routine
		go UserCreateServerCall(ctx, userToCreate, client, userChannel, userErrChannel)

		//------------------------------

		contactToCreate := &pb.NewContact{FirstName: newUser.Name, LastName: newUser.Name, Email: "demo@gmail.com", CompanyId: 1}

		// Create a channel to communicate with the goroutine
		contactChannel := make(chan *pb.Contact)
		contactErrChannel := make(chan error)

		//Calling Go routine
		go ContactCreateServerCall(ctx, contactToCreate, client, contactChannel, contactErrChannel)

		//------------------------------

		// Wait for the user to be created and sent through the channel
		select {
		case createdUser := <-userChannel:
			fmt.Printf("User Created: Id: %d, Name: %s, Age: %d\n", createdUser.GetId(), createdUser.GetName(), createdUser.GetAge())
			c.JSON(http.StatusOK, gin.H{
				"user":  createdUser,
				"user2": createdUser,
			})
		case err := <-userErrChannel:
			log.Fatalf("could not create user: %v", err)
			c.JSON(http.StatusInternalServerError, gin.H{
				"error": err.Error(),
			})
		case <-ctx.Done():
			log.Fatalf("UserCreateServerCall request timed out")
			c.JSON(http.StatusInternalServerError, gin.H{
				"error": ctx.Err().Error(),
			})
		}
	}
}

func UserCreateServerCall(ctx context.Context, userToCreate *pb.NewUser, client pb.UserManagementClient, userChannel chan<- *pb.User, errChannel chan<- error) {

	defer close(userChannel)
	defer close(errChannel)

	createdUser, err := client.CreateNewUser(ctx, userToCreate)

	if err != nil {
		errChannel <- errors.New(err.Error())
	} else if createdUser.Id == 0 {
		errChannel <- errors.New("failed to create user")
	} else {
		// Send the created user through the channel
		userChannel <- createdUser
	}

	fmt.Println("closed")
}

func ContactCreateServerCall(ctx context.Context, contactToCreate *pb.NewContact, client pb.UserManagementClient, contactChannel chan<- *pb.Contact, errChannel chan<- error) {

	defer close(contactChannel)
	defer close(errChannel)

	createdContact, err := client.CreateNewContact(ctx, contactToCreate)

	if err != nil {
		errChannel <- errors.New(err.Error())
	} else if createdContact.Id == 0 {
		errChannel <- errors.New("failed to create user")
	} else {
		// Send the created user through the channel
		fmt.Printf("Contact Created: Id: %d, Name: %s, Age: %s\n", createdContact.Id, createdContact.FirstName, createdContact.LastName)
		contactChannel <- createdContact
	}

	fmt.Println("closed")
}
