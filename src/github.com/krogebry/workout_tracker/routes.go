package main

import (
	"github.com/gorilla/mux"
	"net/http"
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
		var handler http.Handler

		handler = route.HandlerFunc
		handler = Logger(handler, route.Name)

		router.
			Methods(route.Method).
			Path(route.Pattern).
			Name(route.Name).
			Handler(handler)
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
		"ViewExcercise",
		"GET",
		"/excercises/{excerciseId}",
		ViewExcercise,
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
		"secrets",
		"GET",
		"/secrets",
		StatusSecrets,
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
