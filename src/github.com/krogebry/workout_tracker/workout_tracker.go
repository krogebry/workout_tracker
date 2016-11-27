package main

import (
  //"fmt"
  "log"
  //"html"
  //"time"
  "net/http"
  //"encoding/json"

  //"github.com/gorilla/mux"
)


func main() {
  router := NewRouter()
  log.Fatal(http.ListenAndServe(":8080", router))
}

