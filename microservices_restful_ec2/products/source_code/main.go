package main

import (
	"os"

	"github.com/gin-gonic/gin"
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_restful_ec2/_database/initializers"
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_restful_ec2/products/source_code/controllers"
)

func init() {
	//initializers.LoadEnvVariables()
	initializers.ConnectToDB()
}

func main() {
	r := gin.Default()
	r.POST("/product_create", controllers.ProductCreate)
	r.GET("/product_list", controllers.ProductList)
	r.GET("/product_get/:id", controllers.ProductGet)
	r.POST("/product_update/:id", controllers.ProductUpdate)
	r.DELETE("/product_delete/:id", controllers.ProductDelete)
	//r.Run() // listen and serve on 0.0.0.0:env(PORT)

	err := r.Run(":" + os.Getenv("PORT"))
	if err != nil {
		panic("[Error] failed to start Gin server due to: " + err.Error())
	}
}
