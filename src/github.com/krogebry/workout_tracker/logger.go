package main

import (
  //"log"
  "time"
  "net/http"
  log "github.com/Sirupsen/logrus"
)

func Logger(inner http.Handler, name string) http.Handler {
  return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
    start := time.Now()

    inner.ServeHTTP(w, r)

    log.WithFields(log.Fields{
      "uri": r.RequestURI,
      "name": name,
      "method": r.Method,
      "runtime": time.Since(start),
    }).Info("Log")
  })
}
