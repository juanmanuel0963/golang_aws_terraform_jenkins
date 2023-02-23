package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"time"

	pb "github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_grpc_ec2/usermgmt_op4_db_postgres/usermgmt"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

const (
// address = "localhost:50054"
// address = "172.31.92.9:50051"
)

func main() {
	//conn, err := grpc.Dial(address, grpc.WithTransportCredentials(insecure.NewCredentials()))
	conn, err := grpc.Dial(os.Getenv("server_address")+":50054", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()
	c := pb.NewUserManagementClient(conn)

	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	var new_users = make(map[string]int)
	new_users["Alice"] = 43
	new_users["Bob"] = 30
	for name, age := range new_users {
		r, err := c.CreateNewUser(ctx, &pb.NewUser{Name: name, Age: int32(age)})
		if err != nil {
			log.Fatalf("could not create user: %v", err)
		}
		log.Printf(`User Details:
		NAME: %s
		AGE: %d
		ID: %d`, r.GetName(), r.GetAge(), r.GetId())
	}

	params := &pb.GetUsersParams{}
	fmt.Print("Params: ", params)

	r, err := c.GetUsers(ctx, params)
	if err != nil {
		log.Fatalf("could not get users: %v", err)
	}

	log.Print("\n USERs LIST: \n")
	fmt.Printf("r.GetUsers(): %v\n", r.GetUsers())
}
