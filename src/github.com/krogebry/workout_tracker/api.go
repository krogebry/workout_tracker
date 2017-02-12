package main

import (
    "fmt"
    "net/http"
    //"encoding/json"
    //"github.com/gorilla/mux"
)

func Index(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintln(w, "Welcome!")
}
