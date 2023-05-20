package main

import (
	"database/sql"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"strings"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	_ "github.com/go-sql-driver/mysql"
)

type Contoh struct {
	Nama   string `json:"nama"`
	Gambar string `json:"gambar"`
}

func OpenDatabase() (*sql.DB, error) {
	db, err := sql.Open("mysql", "root:@tcp(localhost:3306)/contohgo")
	if err != nil {
		return nil, err
	}
	return db, nil
}

func upload(c echo.Context) error {
	// Source
	file, err := c.FormFile("file")
	if err != nil {
		return err
	}
	src, err := file.Open()
	if err != nil {
		return err
	}
	defer src.Close()

	// Destination
	uploadDir := "upload/" // Tentukan direktori penyimpanan di sini
	os.MkdirAll(uploadDir, os.ModePerm)
	dstPath := filepath.Join(uploadDir, file.Filename)
	dst, err := os.Create(dstPath)
	if err != nil {
		return err
	}
	defer dst.Close()

	// Salin file
	if _, err = io.Copy(dst, src); err != nil {
		return err
	}

	// Simpan data ke database
	contoh := Contoh{
		Nama:   c.FormValue("nama"),
		Gambar:  file.Filename,
	}

	// Dapatkan objek *sql.DB dari fungsi OpenDatabase()
	db, err := OpenDatabase()
	if err != nil {
		return err
	}
	defer db.Close()

	// Menjalankan query INSERT
	_, err = db.Exec("INSERT INTO contoh (nama, gambar) VALUES (?, ?)", contoh.Nama, contoh.Gambar)
	if err != nil {
		return err
	}

	return c.JSON(http.StatusOK, "statusoke")
}

func serveImage(c echo.Context) error {
	imagePath := strings.TrimPrefix(c.Request().URL.Path, "/assets/")
	imagePath = filepath.Join("upload/", imagePath)
	return c.File(imagePath)
}

func main() {
	e := echo.New()

	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	e.POST("/upload", upload)
	e.GET("/assets/*", serveImage)

	e.Logger.Fatal(e.Start(":1323"))
}
