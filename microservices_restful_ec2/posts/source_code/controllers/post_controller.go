package controllers

import (
	"github.com/gin-gonic/gin"
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_restful_ec2/_database/initializers"
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_restful_ec2/_database/models"
)

func PostCreate(c *gin.Context) {

	// Get data off req body
	var body struct {
		Title  string
		Body   string
		BlogID uint
	}
	c.Bind(&body)

	// Crete a post
	post := models.Post{Title: body.Title, Body: body.Body, BlogID: body.BlogID}
	result := initializers.DB.Create(&post)

	if result.Error != nil {
		c.Status(400)
		return
	}

	// Return it
	c.JSON(200, gin.H{
		"post": post,
	})
}

func PostList(c *gin.Context) {

	// Get the posts list
	var posts []models.Post
	initializers.DB.Find(&posts)

	//Respond with them
	c.JSON(200, gin.H{
		"posts": posts,
	})
}

func PostGet(c *gin.Context) {

	//Get the id off url
	id := c.Param("id")

	// Get the post
	var post models.Post
	initializers.DB.First(&post, id)

	//Respond with it
	c.JSON(200, gin.H{
		"post": post,
	})
}

func PostGetByBlogId(c *gin.Context) {
	//Get the id off url
	BlogID := c.Param("blogid")

	// Get the posts
	var posts []models.Post

	// Get all matched records
	result := initializers.DB.Where("blog_id = ?", BlogID).Find(&posts)
	// SELECT * FROM posts WHERE blog_id = BlogID param;

	// returns count of records found
	rows := result.RowsAffected

	status_message := "RECORD_OK"
	status_code := 200
	status_error := ""

	// returns error or nil
	if result.Error != nil {
		status_error = result.Error.Error()
		status_message = "RECORD_UNKNOWN_ERROR"
		status_code = 500
	}

	// check error ErrRecordNotFound
	//if errors.Is(result.Error, gorm.ErrRecordNotFound)

	if result.RowsAffected == 0 {
		status_message = "RECORD_NOT_FOUND"
		status_code = 400
	}

	//Respond with it
	c.JSON(200, gin.H{
		"posts":          posts,
		"row_count":      rows,
		"status_message": status_message,
		"status_code":    status_code,
		"status_error":   status_error,
	})
}

func PostUpdate(c *gin.Context) {

	//Get the id off url
	id := c.Param("id")

	// Get the data off req body
	var body struct {
		Title string
		Body  string
	}
	c.Bind(&body)

	// Find the post were updating
	var post models.Post
	initializers.DB.First(&post, id)

	// Update it
	initializers.DB.Model(&post).Updates(models.Post{Title: body.Title, Body: body.Body})

	// Respond with id
	c.JSON(200, gin.H{
		"post": post,
	})
}

func PostDelete(c *gin.Context) {

	//Get the id off the url
	id := c.Param("id")

	//Delete the post
	initializers.DB.Delete(&models.Post{}, id)

	//Respond
	c.Status(200)
}
