package main

import (
	"encoding/json"
	"os"

	"github.com/dweomer/go-what"
	"github.com/dweomer/go-what/pkg/machine"
)

func main() {
	m, err := what.Machine(machine.WithUTS())
	if err != nil {
		panic(err)
	}
	enc := json.NewEncoder(os.Stdout)
	enc.SetIndent("", "  ")
	enc.Encode(m)
}
