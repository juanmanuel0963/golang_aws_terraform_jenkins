package main

import (
	"os"

	"github.com/gin-gonic/gin"
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_restful_ec2/_database/initializers"
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_restful_ec2/posts/source_code/controllers"
)

func init() {
	//initializers.LoadEnvVariables()
	initializers.ConnectToDB()
}

func main() {
	r := gin.Default()
	r.POST("/post_create", controllers.PostCreate)
	r.GET("/post_list", controllers.PostList)
	r.GET("/post_get/:id", controllers.PostGet)
	r.POST("/post_update/:id", controllers.PostUpdate)
	r.DELETE("/post_delete/:id", controllers.PostDelete)
	//r.Run() // listen and serve on 0.0.0.0:env(PORT)

	err := r.Run(":" + os.Getenv("PORT"))
	if err != nil {
		panic("[Error] failed to start Gin server due to: " + err.Error())
	}
}
