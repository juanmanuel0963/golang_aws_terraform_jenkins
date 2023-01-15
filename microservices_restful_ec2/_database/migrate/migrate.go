package main

import (
	"fmt"

	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_restful_ec2/_database/initializers"
	"github.com/juanmanuel0963/golang_aws_terraform_jenkins/v2/microservices_restful_ec2/_database/models"
)

func init() {
	//initializers.LoadEnvVariables()
	initializers.ConnectToDB()
}

func main() {

	//----------Blogs and Posts----------

	initializers.DB.AutoMigrate(&models.Blog{}, &models.Post{})

	var blogs = []models.Blog{
		{Title: "Blog 1", Posts: []models.Post{{Title: "Blog 1 - Post 1", Body: "Blog 1 - Post 1 - Body"}, {Title: "Blog 1 - Post 2", Body: "Blog 1 - Post 2 - Body"}}},
		{Title: "Blog 2", Posts: []models.Post{{Title: "Blog 2 - Post 1", Body: "Blog 2 - Post 1 - Body"}, {Title: "Blog 2 - Post 2", Body: "Blog 2 - Post 2 - Body"}}},
		{Title: "Blog 3", Posts: []models.Post{{Title: "Blog 3 - Post 1", Body: "Blog 3 - Post 1 - Body"}, {Title: "Blog 3 - Post 2", Body: "Blog 3 - Post 2 - Body"}}},
	}

	initializers.DB.Create(&blogs)

	for _, blog := range blogs {
		fmt.Println("Blog: ", blog.ID) // 1,2,3
		for _, post := range blog.Posts {
			fmt.Println("	Post: ", post.ID) // 1,2,3
		}
	}

	////----------Adding a new Post to a Blog//----------
	var id uint
	row := initializers.DB.Table("blogs").Where("id = ?", 1).Select("id").Row()
	row.Scan(&id)

	post := models.Post{Title: "Blog 4 - Post 1", Body: "Blog 4 - Post 1 - Body", BlogID: id}
	initializers.DB.Create(&post)

	//----------Invoices and Products----------

	initializers.DB.AutoMigrate(&models.Invoice{}, &models.Product{})

	var products = []models.Product{
		{Title: "Product 1"},
		{Title: "Product 2"},
		{Title: "Product 3"},
	}

	initializers.DB.Create(&products)

	var newproduct0 = products[0]
	fmt.Println("Product: ", newproduct0.ID)

	var newproduct1 = products[1]
	fmt.Println("Product: ", newproduct1.ID)

	var newproduct2 = products[2]
	fmt.Println("Product: ", newproduct2.ID)

	var invoices = []models.Invoice{
		{Title: "Invoice 1", Products: []models.Product{newproduct0, newproduct1, newproduct2}},
		{Title: "Invoice 2", Products: []models.Product{newproduct0, newproduct1, newproduct2}},
		{Title: "Invoice 3", Products: []models.Product{newproduct0, newproduct1, newproduct2}},
	}

	initializers.DB.Create(&invoices)

	for _, invoice := range invoices {
		fmt.Println("Invoice: ", invoice.ID) // 1,2,3
		for _, product := range invoice.Products {
			fmt.Println("	Product: ", product.ID) // 1,2,3
		}
	}

}
