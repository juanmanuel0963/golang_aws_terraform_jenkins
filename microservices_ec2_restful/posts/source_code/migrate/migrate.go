package main

import (
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_ec2_restful/posts/source_code/initializers"
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_ec2_restful/posts/source_code/models"
)

func init() {
	initializers.LoadEnvVariables()
	initializers.ConnectToDB()
}

func main() {
	initializers.DB.AutoMigrate(&models.Post{})
}
