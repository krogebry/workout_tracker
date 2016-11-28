package main

import (
  "net/http"
  "github.com/gorilla/mux"
)

type Route struct {
  Name        string
  Method      string
  Pattern     string
  HandlerFunc http.HandlerFunc
}

type Routes []Route

func NewRouter() *mux.Router {
  router := mux.NewRouter().StrictSlash(true)
  for _, route := range routes {
    router.
      Methods(route.Method).
      Path(route.Pattern).
      Name(route.Name).
      Handler(route.HandlerFunc)
  }
  return router
}

var routes = Routes{
  Route{
    "Index",
    "GET",
    "/",
    Index,
  },

  Route{
    "Workouts",
    "GET",
    "/workouts",
    ListWorkouts,
  },

  Route{
    "ViewWorkout",
    "GET",
    "/workouts/{workoutId}",
    ViewWorkout,
  },

  Route{
    "CreateWorkout",
    "POST",
    "/workouts",
    CreateWorkout,
  },

  Route{
    "LogExcerciseRepitition",
    "POST",
    "/workouts/excercise/{excerciseId}/log_reps",
    LogExcerciseRepitition,
  },





  Route{
    "TodoIndex",
    "GET",
    "/todos",
    TodoIndex,
  },
  Route{
    "TodoShow",
    "GET",
    "/todos/{todoId}",
    TodoShow,
  },

  Route{
    "version",
    "GET",
    "/version",
    StatusVersion,
  },

  Route{
    "healthz",
    "GET",
    "/healthz",
    Healthz,
  },

}



