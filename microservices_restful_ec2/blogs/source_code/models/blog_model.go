package models

import "gorm.io/gorm"

type Post struct {
	gorm.Model
	Title string
	Body  string
}

type Blog struct {
	gorm.Model
	Title string
	Post  Post
}
