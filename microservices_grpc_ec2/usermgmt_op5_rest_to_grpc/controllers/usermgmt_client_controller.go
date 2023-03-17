package controllers

import (
	"context"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	pb "github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_grpc_ec2/usermgmt_op5_rest_to_grpc/usermgmt"
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_restful_ec2/_database/models"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

func UserCreate(contexto *gin.Context) {

	//conn, err := grpc.Dial(address, grpc.WithTransportCredentials(insecure.NewCredentials()))
	conn, err := grpc.Dial(os.Getenv("server_address")+":50055", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()
	client := pb.NewUserManagementClient(conn)

	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()

	var new_users = []models.User{
		{Name: "Moe REST controller to GRPC", Age: 41},
		{Name: "Larry REST controller to GRPC", Age: 42},
		{Name: "Curley REST controller to GRPC", Age: 43},
	}

	for _, user := range new_users {

		r, err := client.CreateNewUser(ctx, &pb.NewUser{Name: user.Name, Age: user.Age})

		if err != nil {
			log.Fatalf("could not create user: %v", err)
		} else {
			fmt.Printf("User Details: Id: %d, Name: %s, Age: %d\n", r.GetId(), r.GetName(), r.GetAge())
		}

	}

	/*
		params := &pb.GetUsersParams{}
		fmt.Print("Params: ", params)

		r, err := c.GetUsers(ctx, params)
		if err != nil {
			log.Fatalf("could not get users: %v", err)
		}

		log.Print("\n USERs LIST: \n")
		fmt.Printf("r.GetUsers(): %v\n", r.GetUsers())
	*/
}