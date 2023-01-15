package main

import (
	"context"
	"fmt"
	"log"
	"net"
	"os"

	"github.com/jackc/pgx/v4"
	pb "github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_grpc_ec2/usermgmt_op4_db_postgres/usermgmt"
	"google.golang.org/grpc"
)

const (
	port = ":50054"
)

func NewUserManagementServer() *UserManagementServer {
	return &UserManagementServer{}
}

type UserManagementServer struct {
	conn                *pgx.Conn
	first_user_creation bool
	pb.UnimplementedUserManagementServer
}

func (server *UserManagementServer) Run() error {
	lis, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	s := grpc.NewServer()
	pb.RegisterUserManagementServer(s, server)
	log.Printf("server listening at %v", lis.Addr())

	return s.Serve(lis)
}

// When user is added, read full userlist from file into
// userlist struct, then append new user and write new userlist back to file
func (server *UserManagementServer) CreateNewUser(ctx context.Context, in *pb.NewUser) (*pb.User, error) {

	createSql := `
	create table if not exists users(
		id SERIAL PRIMARY KEY,
		name text,
		age int
	);
	`
	_, err := server.conn.Exec(context.Background(), createSql)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Table creation failed: %v\n", err)
		os.Exit(1)
	}

	server.first_user_creation = false

	log.Printf("Received: %v", in.GetName())

	created_user := &pb.User{Name: in.GetName(), Age: in.GetAge()}
	tx, err := server.conn.Begin(context.Background())
	if err != nil {
		log.Fatalf("conn.Begin failed: %v", err)
	}

	_, err = tx.Exec(context.Background(), "insert into users(name, age) values ($1,$2)",
		created_user.Name, created_user.Age)
	if err != nil {
		log.Fatalf("tx.Exec failed: %v", err)
	}
	tx.Commit(context.Background())
	return created_user, nil

}

func (server *UserManagementServer) GetUsers(ctx context.Context, in *pb.GetUsersParams) (*pb.UsersList, error) {

	var users_list *pb.UsersList = &pb.UsersList{}
	rows, err := server.conn.Query(context.Background(), "select * from users")
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	for rows.Next() {
		user := pb.User{}
		err = rows.Scan(&user.Id, &user.Name, &user.Age)
		if err != nil {
			return nil, err
		}
		users_list.Users = append(users_list.Users, &user)

	}
	return users_list, nil
}

func main() {
	//database_url1 := "postgres://postgres:mysecretpassword@localhost:5432/postgres"
	database_url := "postgres://db_master:" + os.Getenv("db_password") + os.Getenv("db_conn")
	//database_url := "postgres://db_master:" + os.Getenv("db_password") + "@db-server-postgresql-romantic-shark.cm03k8s4ogkh.us-east-1.rds.amazonaws.com:5432/db_postgresql_romantic_shark?sslmode=disable"
	var user_mgmt_server *UserManagementServer = NewUserManagementServer()
	conn, err := pgx.Connect(context.Background(), database_url)
	if err != nil {
		log.Fatalf("Unable to establish connection: %v, db_conn: %v, db_pass: %v", err, os.Getenv("db_conn"), os.Getenv("db_password"))
	}
	defer conn.Close(context.Background())
	user_mgmt_server.conn = conn
	user_mgmt_server.first_user_creation = true
	if err := user_mgmt_server.Run(); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
