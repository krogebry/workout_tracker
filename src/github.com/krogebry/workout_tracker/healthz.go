package main

import (
  "fmt"
  //"log"
  //"html"
  //"time"
  "net/http"
  //"encoding/json"
  //"github.com/gorilla/mux"
)

var (
  Version   string
  BuildTime string
)

func StatusVersion(w http.ResponseWriter, r *http.Request) {
  fmt.Fprintf(w, "Version: %q - %q", Version, BuildTime)
}

