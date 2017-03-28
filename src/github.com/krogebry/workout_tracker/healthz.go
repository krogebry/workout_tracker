package main

import (
	"encoding/json"
	"net/http"
	"os"
)

var (
	Version   string
	BuildTime string
)

type VersionInfo struct {
	Version   string `json:"version"`
	BuildTime string `json:"build_time"`
	Hostname  string `json:"hostname"`
}

type SecretInfo struct {
	DBSecret   string `json:"DBSecret"`
	APISecret  string `json:"APISecret"`
	UnlockCode string `json:"UnlockCode"`
}

type HealthInfo struct {
	Status string `json:"version"`
}

func StatusSecrets(w http.ResponseWriter, r *http.Request) {
	info := SecretInfo{os.Getenv("DBSecret"), os.Getenv("APISecret"), os.Getenv("UnlockCode")}
	if err := json.NewEncoder(w).Encode(info); err != nil {
		panic(err)
	}
}

func StatusVersion(w http.ResponseWriter, r *http.Request) {
	info := VersionInfo{Version, BuildTime, ""}
	if err := json.NewEncoder(w).Encode(info); err != nil {
		panic(err)
	}
}

func Healthz(w http.ResponseWriter, r *http.Request) {
	info := HealthInfo{"up"}
	if err := json.NewEncoder(w).Encode(info); err != nil {
		panic(err)
	}
}
