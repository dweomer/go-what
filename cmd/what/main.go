package main

import (
	"encoding/json"
	"github.com/dweomer/go-what"
	"github.com/dweomer/go-what/pkg/machine"
	"os"
)

func main() {
	m, err := what.Machine(machine.WithUTS())
	if err != nil {
		panic(err)
	}
	json.NewEncoder(os.Stdout).Encode(m)
}
