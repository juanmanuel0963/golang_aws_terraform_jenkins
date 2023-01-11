package main

import (
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_restful_ec2/posts/source_code/initializers"
)

func init() {
	//initializers.LoadEnvVariables()
	initializers.ConnectToDB()
}

func main() {
	//initializers.DB.AutoMigrate(&models.Post{})
}
