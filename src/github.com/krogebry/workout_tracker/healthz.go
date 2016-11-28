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

func StatusVersion(w http.ResponseWriter, r *http.Request) {
  //fmt.Fprintf(w, "Version: %q - %q", Version, BuildTime)

  info := VersionInfo{ Version, BuildTime, "" }

  if err := json.NewEncoder(w).Encode(info); err != nil {
    panic(err)
  }
}

