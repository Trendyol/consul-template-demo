package main

import (
	"consul-template-demo/config"
	"github.com/labstack/echo/v4"
	"net/http"
)

func main() {
	configManager := config.NewConfigurationManager("./config/app-config.yml")
	conf := configManager.Get()

	e := echo.New()
	e.GET("/configs", func(c echo.Context) error {
		return c.JSON(http.StatusOK, conf)
	})

	e.Logger.Fatal(e.Start(":" + conf.Server.Port))
}
