package config

import (
	"github.com/fsnotify/fsnotify"
	"github.com/spf13/viper"
	"log"
)

type ApplicationConfig struct {
	Server   ServerConfig
	Toggles  TogglesConfig
	Database DatabaseConfig
}

type ServerConfig struct {
	Port string
}

type TogglesConfig struct {
	FooEnabled bool
}
type DatabaseConfig struct {
	Username string
	Password string
}

type configurationManager struct {
	configurationFile string
	configuration     ApplicationConfig
}

func (configurationManager *configurationManager) Get() *ApplicationConfig {
	return &configurationManager.configuration
}

func NewConfigurationManager(configurationFile string) *configurationManager {
	v := viper.New()
	v.SetConfigFile(configurationFile)
	v.WatchConfig()
	if err := v.ReadInConfig(); err != nil {
		log.Fatal(err)
	}

	cm := &configurationManager{
		configurationFile: configurationFile,
		configuration:     unmarshallConfig(v),
	}

	v.OnConfigChange(func(in fsnotify.Event) {
		cm.configuration = unmarshallConfig(v)
	})

	return cm
}

func unmarshallConfig(v *viper.Viper) ApplicationConfig {
	configuration := ApplicationConfig{}
	if err := v.Unmarshal(&configuration); err != nil {
		log.Fatal(err)
	}
	return configuration
}
