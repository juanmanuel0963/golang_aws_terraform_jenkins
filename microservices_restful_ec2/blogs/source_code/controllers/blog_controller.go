package controllers

import (
	"github.com/gin-gonic/gin"
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_restful_ec2/_database/initializers"
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_restful_ec2/_database/models"
)

func BlogCreate(c *gin.Context) {

	// Get data off req body
	var body struct {
		Title string
	}
	c.Bind(&body)

	// Crete a post
	blog := models.Blog{Title: body.Title}
	result := initializers.DB.Create(&blog)

	if result.Error != nil {
		c.Status(400)
		return
	}

	// Return it
	c.JSON(200, gin.H{
		"post": blog,
	})
}

func BlogList(c *gin.Context) {

	// Get the blogs list
	var blogs []models.Blog
	initializers.DB.Find(&blogs)

	//Respond with them
	c.JSON(200, gin.H{
		"blogs": blogs,
	})
}

func BlogGet(c *gin.Context) {

	//Get the id off url
	id := c.Param("id")

	// Get the blog
	var blog models.Blog
	initializers.DB.First(&blog, id)

	//Respond with it
	c.JSON(200, gin.H{
		"blog": blog,
	})
}

func BlogUpdate(c *gin.Context) {

	//Get the id off url
	id := c.Param("id")

	// Get the data off req body
	var body struct {
		Title string
	}
	c.Bind(&body)

	// Find the blog were updating
	var blog models.Blog
	initializers.DB.First(&blog, id)

	// Update it
	initializers.DB.Model(&blog).Updates(models.Blog{Title: body.Title})

	// Respond with id
	c.JSON(200, gin.H{
		"blog": blog,
	})
}

func BlogDelete(c *gin.Context) {

	//Get the id off the url
	id := c.Param("id")

	//Delete the post
	initializers.DB.Delete(&models.Blog{}, id)

	//Respond
	c.Status(200)
}
