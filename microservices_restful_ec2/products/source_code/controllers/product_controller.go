package controllers

import (
	"github.com/gin-gonic/gin"
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_restful_ec2/_database/initializers"
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_restful_ec2/_database/models"
)

func ProductCreate(c *gin.Context) {

	// Get data off req body
	/*var body struct {
		Title string
	}
	c.Bind(&body)
	*/
	// Crete a post
	product := models.Product{Title: "My titular"}
	//product := models.Product{Title: body.Title}
	result := initializers.DB.Create(&product)

	if result.Error != nil {
		c.Status(400)
		return
	}

	// Return it
	c.JSON(200, gin.H{
		"product": product,
	})
}

func ProductList(c *gin.Context) {

	// Get the products list
	var products []models.Product
	initializers.DB.Find(&products)

	//Respond with them
	c.JSON(200, gin.H{
		"products": products,
	})
}

func ProductGet(c *gin.Context) {

	//Get the id off url
	id := c.Param("id")

	// Get the product
	var product models.Product
	initializers.DB.First(&product, id)

	//Respond with it
	c.JSON(200, gin.H{
		"product": product,
	})
}

func ProductUpdate(c *gin.Context) {

	//Get the id off url
	id := c.Param("id")

	// Get the data off req body
	var body struct {
		Title string
	}
	c.Bind(&body)

	// Find the product were updating
	var product models.Product
	initializers.DB.First(&product, id)

	// Update it
	initializers.DB.Model(&product).Updates(models.Product{Title: body.Title})

	// Respond with id
	c.JSON(200, gin.H{
		"product": product,
	})
}

func ProductDelete(c *gin.Context) {

	//Get the id off the url
	id := c.Param("id")

	//Delete the post
	initializers.DB.Delete(&models.Product{}, id)

	//Respond
	c.Status(200)
}
