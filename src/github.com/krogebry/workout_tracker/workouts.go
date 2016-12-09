package main

import (
  //"fmt"
  //"time"
  "strconv"
  "net/http"
  //"math/rand"
  "encoding/json"
  "gopkg.in/mgo.v2"
  "gopkg.in/mgo.v2/bson"
  "github.com/gorilla/mux"
  log "github.com/Sirupsen/logrus"
)

type Workout struct {
  Name  string
  Type  string
  IsDaily     bool
  Excercises  []Excercise
}

type Workouts []Workout

type Excercise struct {
  Id    int
  Name  string
  Type  string
}

func ListWorkouts(w http.ResponseWriter, r *http.Request) {
  log.Print("Connecting to db")
  session, err := mgo.Dial("database")
  log.Print("Connected to db")
  if err != nil {
    panic(err)
  }
  defer session.Close()

  log.Print("Running query.")

  c := session.DB("workout_tracker").C("workouts")

  log.Print("Created connector")

  result := Workout{}
  err = c.Find(bson.M{"owner_email": "bryan.kroger@gmail.com"}).One(&result)
  if err != nil {
    log.Printf("Unable to find results: %s", err)
    //log.Fatal(err)
  }

  //log.Printf("Returning %i results")
  if err := json.NewEncoder(w).Encode(result); err != nil {
    log.Print("Error reporting results.")
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
}

func ViewExcercise(w http.ResponseWriter, r *http.Request) {
  //t := time.Now()
  //log.WithFields(log.Fields{
    //"timestamp": t,
  //}).Info("Entered ViewExcercise")

  vars := mux.Vars(r)

  excerciseId, err := strconv.Atoi( vars["excerciseId"] )
  if err != nil {
    panic(err)
  }

  ex := Excercise{}
  ex.Id = excerciseId

  //rand.Seed(42)
  //time.Sleep( time.Duration(rand.Intn( 10 ))*time.Millisecond )

  //t_done := time.Now()

  //log.Printf("ExId: %i", ex.Id)
  //log.WithFields(log.Fields{
    //"runtime": t_done.Sub( t ),
    //"timestamp": t_done,
    //"excerciseId": ex.Id,
  //}).Info("Returning results")

  if err := json.NewEncoder( w ).Encode( ex ); err != nil {
    log.Print("Error encoding excercise")
    panic(err)
  }
}

