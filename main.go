package main

import (
	"database/sql"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"time"


	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	_ "github.com/go-sql-driver/mysql"
)

type Cerita struct {
	Judul     string `json:"judul"`
	Gambar    string `json:"gambar"`
	Video     string `json:"videourl"`
	Ceritax   string `json:"deskripsi"`
	IdPenulis string `json:"fkg_penulis"`
	Likes     string `json:"likes"`
	IdCerita  string `json:"id_cerita"`
}

type AnakModel struct{

}

type UsersModel struct{

}

func OpenDatabase() (*sql.DB, error) {
	db, err := sql.Open("mysql", "root:@tcp(localhost:3306)/sicandb")
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
	uploadDir := "upload/"
	os.MkdirAll(uploadDir, os.ModePerm)
	fileExtension := filepath.Ext(file.Filename)
	fileName := time.Now().Format("20060102150405") + "-" + c.FormValue("id_penulis") + fileExtension

	dstPath := filepath.Join(uploadDir, fileName)
	dst, err := os.Create(dstPath)
	if err != nil {
		return err
	}
	defer dst.Close()

	// Salin file gambar
	if _, err = io.Copy(dst, src); err != nil {
		return err
	}

	// Video
	video, err := c.FormFile("video")
	if err != nil {
		return err
	}
	srcVideo, err := video.Open()
	if err != nil {
		return err
	}
	defer srcVideo.Close()
	videoExtension := filepath.Ext(video.Filename)
	videoName := time.Now().Format("20060102150405") + "-" + c.FormValue("id_penulis") + videoExtension
	dstVideoPath := filepath.Join(uploadDir, videoName)
dstVideo, err := os.Create(dstVideoPath)
	if err != nil {
		return err
	}
	defer dstVideo.Close()

	// Salin file video
	if _, err = io.Copy(dstVideo, srcVideo); err != nil {
		return err
	}

	// Simpan data ke database
	cerita := Cerita{
		Judul:     c.FormValue("judul"),
		Gambar:    fileName,
		Video:     videoName,
		Ceritax:   c.FormValue("cerita"),
		IdPenulis: c.FormValue("id_penulis"),
	}

	// Dapatkan objek *sql.DB dari fungsi OpenDatabase()
	db, err := OpenDatabase()
	if err != nil {
		return err
	}
	defer db.Close()

	// Menjalankan query INSERT
	_, err = db.Exec("call tambah_data_tbl_cerita(?, ?, ?,  '1', ?, '0',?)", cerita.Judul, cerita.Video,cerita.Ceritax,cerita.IdPenulis,cerita.Gambar)
	if err != nil {
		return err
	}
	return c.JSON(http.StatusOK, map[string]interface{}{
		"metadata": map[string]interface{}{
			"code":   200,
			"status": "ok",
		},
	})
}



func getCeritaAll(c echo.Context) error {
	db, err := OpenDatabase()
	if err != nil {
		return err
	}
	defer db.Close()
	rows, err := db.Query("SELECT id_cerita, judul, videourl, gambar, deskripsi, fkg_penulis, likes FROM tbl_cerita")
	if err != nil {
		return err
	}
	defer rows.Close()
	data := []Cerita{}
	for rows.Next() {
		var cerita Cerita
		err := rows.Scan(&cerita.IdCerita, &cerita.Judul, &cerita.Video, &cerita.Gambar, &cerita.Ceritax, &cerita.IdPenulis, &cerita.Likes)
		if err != nil {
			return err
		}
		data = append(data, cerita)
	}
	if err = rows.Err(); err != nil {
		return err
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"metadata": map[string]interface{}{
			"code":   200,
			"status": "ok",
		},
		"response": data,
	})
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
	e.Use(allowAllOriginsMiddleware())

	e.POST("/upload", upload)
	e.GET("/assets/*", serveImage)
	e.GET("/cerita", getCeritaAll)
	err := e.Start(":1323")
	if err != nil {
		e.Logger.Fatal(err)
	}
}

func AllowAllOriginsMiddleware(next echo.HandlerFunc) echo.HandlerFunc {
    return func(c echo.Context) error {
        c.Response().Header().Set(echo.HeaderAccessControlAllowOrigin, "*")
        c.Response().Header().Set(echo.HeaderAccessControlAllowMethods, "GET, POST, PUT, DELETE, OPTIONS")
        c.Response().Header().Set(echo.HeaderAccessControlAllowHeaders, "Content-Type, Authorization")

        if c.Request().Method == echo.OPTIONS {
            return c.NoContent(http.StatusNoContent)
        }

        return next(c)
    }
}
func allowAllOriginsMiddleware() echo.MiddlewareFunc {
	return func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			c.Response().Header().Set(echo.HeaderAccessControlAllowOrigin, "*")
			c.Response().Header().Set(echo.HeaderAccessControlAllowMethods, "GET, POST, PUT, DELETE, OPTIONS")
			c.Response().Header().Set(echo.HeaderAccessControlAllowHeaders, "Content-Type, Authorization")

			if c.Request().Method == echo.OPTIONS {
				return c.NoContent(http.StatusNoContent)
			}

			return next(c)
		}
	}
}