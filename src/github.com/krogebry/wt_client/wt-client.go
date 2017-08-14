package main

import (
  "fmt"
  "os"
  "github.com/urfave/cli"
)

func main() {
  app := cli.NewApp()
  app.Name = "Workout Tracker Client"
  app.Usage = "Track workouts"
  
  // app.Action = func(c *cli.Context) error {
  //   fmt.Println("boom! I say!")
  //   return nil
  // }

  app.Commands = []cli.Command{
    cli.Command{
      Name: "record",
      Usage: "Record a workout",
      Flags: []cli.Flag{
        cli.StringFlag{Name: "effort, e"},
      },
      // Action: func(c *cli.Context) error {
      //   //fmt.Printf("%#v\n", c.Args().Present())
      //   return nil
      // },
      Subcommands: []cli.Command{
        cli.Command{
          Name: "cardio",
          Usage: "Record a cardio workout",
          Category: "workout_type",
          Action: func(c *cli.Context) error {
            c.Command.VisibleFlags()
            fmt.Printf("%s\n", c.String("effort"))
            //fmt.Printf("%#v\n", c.Flags().Present())
            return nil
          },
        },
        cli.Command{
          Name: "weights",
          Usage: "Record a lifting workout",
          Category: "workout_type",
          Action: func(c *cli.Context) error {
            //fmt.Printf("%#v\n", c.Args().Present()) 
            return nil
          },
        },
      },
    },

    cli.Command{
      Name: "status",
      Usage: "Get current status",
      Action: func(c *cli.Context) error {
        fmt.Printf("%#v\n", c.Args().Present())
        return nil
      },
    },
  }

  app.Run(os.Args)
}
