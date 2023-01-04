package main

import (
	"github.com/gin-gonic/gin"
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_restful_ec2/source_code/initializers"
)

func init() {
	initializers.LoadEnvVariables()
}

func main() {
	r := gin.Default()
	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong1",
		})
	})
	r.Run() // listen and serve on 0.0.0.0:8080
}
