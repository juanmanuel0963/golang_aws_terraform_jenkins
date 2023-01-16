package controllers

import (
	"errors"

	"github.com/gin-gonic/gin"
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_restful_ec2/_database/initializers"
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_restful_ec2/_database/models"
	"gorm.io/gorm"
)

func ProductCreate(c *gin.Context) {

	// Get data off req body
	var body struct {
		Title string
	}
	c.Bind(&body)

	// Crete a post
	product := models.Product{Title: body.Title}
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
	result := initializers.DB.First(&product, id)

	rows := result.RowsAffected // returns count of records found
	//result.Error                // returns error or nil

	status_message := "RECORD_OK"
	status_code := 200
	status_error := ""

	if result.Error != nil {
		status_error = result.Error.Error()
		status_message = "RECORD_UNKNOWN_ERROR"
		status_code = 500
	}

	// check error ErrRecordNotFound
	if errors.Is(result.Error, gorm.ErrRecordNotFound) {
		status_message = "RECORD_NOT_FOUND"
		status_code = 400
	}

	//Respond with it
	c.JSON(200, gin.H{
		"product":        product,
		"row_count":      rows,
		"status_message": status_message,
		"status_code":    status_code,
		"status_error":   status_error,
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
