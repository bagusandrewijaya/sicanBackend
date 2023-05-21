package middleware

import (
    "net/http"

    "github.com/labstack/echo/v4"
)

// Middleware untuk mengizinkan akses dari semua URL
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
