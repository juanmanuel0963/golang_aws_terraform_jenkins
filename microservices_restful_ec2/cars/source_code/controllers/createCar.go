package controllers

import (
	"errors"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_restful_ec2/_database/initializers"
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_restful_ec2/_database/models"
)

type BodyCar struct {
	Id       int32  `json:"id"`
	Category string `json:"category"`
	Color    string `json:"color"`
	Maker    string `json:"maker"`
	Modelo   string `json:"modelo"`
	Package  string `json:"package"`
	Mileage  int32  `json:"mileage"`
	Year     int32  `json:"year"`
	Price    int32  `json:"price"`
}

func CreateCar(c *gin.Context) {

	var body BodyCar

	// Bind incoming JSON to user struct
	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var newCar = models.Car{Category: body.Category, Color: body.Color, Maker: body.Maker,
		Modelo: body.Modelo, Package: body.Package, Mileage: body.Mileage, Year: body.Year, Price: body.Year}

	// Create a channel to communicate with the goroutine
	carChannel := make(chan models.Car)
	errChannel := make(chan error)

	//Calling Go routine
	go createCar(newCar, carChannel, errChannel)

	// Wait for the car to be created and sent through the channel
	select {
	case createdCar := <-carChannel:
		c.JSON(http.StatusOK, gin.H{
			"car": createdCar,
		})
	case err := <-errChannel:
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
	}
}

func createCar(newCar models.Car, carChannel chan<- models.Car, errChannel chan<- error) {

	defer close(carChannel)
	defer close(errChannel)

	result := initializers.DB.Create(&newCar)

	if result.Error != nil {
		errChannel <- errors.New(result.Error.Error())
	} else if newCar.ID == 0 {
		errChannel <- errors.New("failed to create car")
	} else {
		// Send the created car through the channel
		carChannel <- newCar
	}

	fmt.Println("closed")
}
