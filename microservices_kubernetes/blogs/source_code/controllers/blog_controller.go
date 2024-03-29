package controllers

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/cognito/auth_token/source_code/verify_token"
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_kubernetes/_database/initializers"
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_kubernetes/_database/models"

	"github.com/MicahParks/keyfunc"
	"github.com/golang-jwt/jwt/v4"
)

func VerifyToken(c *gin.Context) bool {
	status := true
	token := c.Request.Header.Get("Authorization")
	if strings.HasPrefix(token, "Bearer ") {

		token = strings.TrimPrefix(token, "Bearer ")
		fmt.Println("token =", token)
		// Get the JWKS URL from your AWS region and userPoolId.
		//
		// See the AWS docs here:
		// https://docs.aws.amazon.com/cognito/latest/developerguide/amazon-cognito-user-pools-using-tokens-verifying-a-jwt.html
		//regionID := "us-east-1" // TODO Get the region ID for your AWS Cognito instance.
		regionID := os.Getenv("region")
		fmt.Println(regionID)

		//userPoolID := "us-east-1_Es8PRfyf2" // TestPoolInfo TODO Get the user pool ID of your AWS Cognito instance.
		//userPoolID := "us-east-1_hnPCjlOjN" // user_pool_curious_sunbeam TODO Get the user pool ID of your AWS Cognito instance.
		userPoolID := os.Getenv("aws_cognito_user_pool_id") // TODO Get the user pool ID of your AWS Cognito instance.
		fmt.Println(userPoolID)

		jwksURL := fmt.Sprintf("https://cognito-idp.%s.amazonaws.com/%s/.well-known/jwks.json", regionID, userPoolID)

		// Create the keyfunc options. Use an error handler that logs. Refresh the JWKS when a JWT signed by an unknown KID
		// is found or at the specified interval. Rate limit these refreshes. Timeout the initial JWKS refresh request after
		// 10 seconds. This timeout is also used to create the initial context.Context for keyfunc.Get.
		options := keyfunc.Options{
			RefreshErrorHandler: func(err error) {
				fmt.Printf("JWT-There was an error with the jwt.Keyfunc\nError: %s\n", err.Error())
			},
			RefreshInterval:   time.Hour,
			RefreshRateLimit:  time.Minute * 5,
			RefreshTimeout:    time.Second * 10,
			RefreshUnknownKID: true,
		}

		// Create the JWKS from the resource at the given URL.
		jwks, err := keyfunc.Get(jwksURL, options)
		if err != nil {
			fmt.Printf("JWT-Failed to create JWKS from resource at the given URL.\nError: %s\n", err.Error())
			status = false
		}

		// Get a JWT to parse.
		//jwtB64 := "eyJraWQiOiJmNTVkOWE0ZSIsInR5cCI6IkpXVCIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiJLZXNoYSIsImF1ZCI6IlRhc2h1YW4iLCJpc3MiOiJqd2tzLXNlcnZpY2UuYXBwc3BvdC5jb20iLCJleHAiOjE2MTkwMjUyMTEsImlhdCI6MTYxOTAyNTE3NywianRpIjoiMWY3MTgwNzAtZTBiOC00OGNmLTlmMDItMGE1M2ZiZWNhYWQwIn0.vetsI8W0c4Z-bs2YCVcPb9HsBm1BrMhxTBSQto1koG_lV-2nHwksz8vMuk7J7Q1sMa7WUkXxgthqu9RGVgtGO2xor6Ub0WBhZfIlFeaRGd6ZZKiapb-ASNK7EyRIeX20htRf9MzFGwpWjtrS5NIGvn1a7_x9WcXU9hlnkXaAWBTUJ2H73UbjDdVtlKFZGWM5VGANY4VG7gSMaJqCIKMxRPn2jnYbvPIYz81sjjbd-sc2-ePRjso7Rk6s382YdOm-lDUDl2APE-gqkLWdOJcj68fc6EBIociradX_ADytj-JYEI6v0-zI-8jSckYIGTUF5wjamcDfF5qyKpjsmdrZJA"
		jwtB64 := token

		// Parse the JWT.
		token, err := jwt.Parse(jwtB64, jwks.Keyfunc)
		if err != nil {
			fmt.Printf("JWT-Failed to parse the JWT.\nError: %s\n", err.Error())
			status = false
		}

		// Check if the token is valid.
		if !token.Valid {
			fmt.Printf("JWT-The token is not valid.\n")
			status = false
		}

		log.Println("JWT-The token is valid.")

		// End the background refresh goroutine when it's no longer needed.
		jwks.EndBackground()
	} else {
		c.String(http.StatusUnauthorized, "Unauthorized")
		status = false
	}
	return status
}

func BlogCreate(c *gin.Context) {
	//if VerifyToken(c) {
	if verify_token.VerifyToken(c) {
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
