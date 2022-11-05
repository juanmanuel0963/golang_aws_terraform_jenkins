package main

import (
	"context"
	"log"
	"time"

	pb "github.com/juanmanuel0963/terraform_jenkins_aws_api_gateway_microservices_lambda_golang_ec2_grpc_postgresql/v4/microservices/usermgmt_op1_no_persistence/usermgmt"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

const (
	// address = "localhost:50051"
	address = "172.31.92.9:50051"
	//os.Getenv("grpc_server_1")
)

func main() {
	conn, err := grpc.Dial(address, grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()
	c := pb.NewUserManagementClient(conn)

	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	var new_users = make(map[string]int32)
	new_users["Alice"] = 43
	new_users["Bob"] = 30
	for name, age := range new_users {
		r, err := c.CreateNewUser(ctx, &pb.NewUser{Name: name, Age: age})
		if err != nil {
			log.Fatalf("could not create user: %v", err)
		}
		log.Printf(`User Details:
NAME: %s
AGE: %d
ID: %d`, r.GetName(), r.GetAge(), r.GetId())

	}
}
