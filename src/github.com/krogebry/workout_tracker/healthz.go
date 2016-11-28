package main

import (
  //"fmt"
  "encoding/json"
  "net/http"
)

var (
  Version   string
  BuildTime string
)

type VersionInfo struct {
  Version   string  `json:"version"`
  BuildTime string  `json:"build_time"`
  Hostname  string  `json:"hostname"`
}

type HealthInfo struct {
  Status    string  `json:"version"`
}

func StatusVersion(w http.ResponseWriter, r *http.Request) {
  info := VersionInfo{ Version, BuildTime, "" }
  if err := json.NewEncoder(w).Encode(info); err != nil {
    panic(err)
  }
}

func Healthz(w http.ResponseWriter, r *http.Request) {
  info := HealthInfo{ "up" }
  if err := json.NewEncoder(w).Encode(info); err != nil {
    panic(err)
  }
}

