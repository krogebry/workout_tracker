package main

import (
  "os"
  "net/http"
  log "github.com/Sirupsen/logrus"
)

func main() {
  log.SetFormatter(&log.JSONFormatter{})
  log.SetOutput(os.Stdout)
  router := NewRouter()
  log.Fatal(http.ListenAndServe(":8080", router))
}

