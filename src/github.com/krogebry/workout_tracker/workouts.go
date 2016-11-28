package main

import (
  //"fmt"
  "log"
  "net/http"
  "encoding/json"
  "gopkg.in/mgo.v2"
  "gopkg.in/mgo.v2/bson"
  //"github.com/gorilla/mux"
)

type Workout struct {
  Name  string
  Type  string
  IsDaily     bool
  Excercises  []Excercise
}

type Workouts []Workout

type Excercise struct {
  Name  string
  Type  string
}

func ListWorkouts(w http.ResponseWriter, r *http.Request) {
  session, err := mgo.Dial("database")
  if err != nil {
    panic(err)
  }
  defer session.Close()

  //log.Info("Connected")

  c := session.DB("workout_tracker").C("workouts")

  result := Workout{}
  err = c.Find(bson.M{"owner_email": "bryan.kroger@gmail.com"}).One(&result)
  if err != nil {
    log.Fatal(err)
  }

  if err := json.NewEncoder(w).Encode(result); err != nil {
    panic(err)
  }
}

func ViewWorkout(w http.ResponseWriter, r *http.Request) {
  //vars := mux.Vars(r)
  //workoutId := vars["workoutId"]
}

func CreateWorkout(w http.ResponseWriter, r *http.Request) {
}

func CreateExcercise(w http.ResponseWriter, r *http.Request) {
}

func LogExcerciseRepitition(w http.ResponseWriter, r *http.Request) {
  //vars := mux.Vars(r)
  //excerciseId := vars["excerciseId"]
}



//func TodoIndex(w http.ResponseWriter, r *http.Request) {
    //todos := Todos{
        //Todo{Name: "Write presentation"},
        //Todo{Name: "Host meetup"},
    //}

    //if err := json.NewEncoder(w).Encode(todos); err != nil {
        //panic(err)
    //}
//}

//func TodoShow(w http.ResponseWriter, r *http.Request) {
    //vars := mux.Vars(r)
    //todoId := vars["todoId"]
    //fmt.Fprintln(w, "Todo show:", todoId)
//}

