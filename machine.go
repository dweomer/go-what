package what

import (
	"github.com/dweomer/go-what/pkg/machine"
	"runtime"
)

// Machine returns a machine.What initialized with the passed 0..n machine.Option
func Machine(opts...machine.Option) (*machine.What,error) {
	m := machine.What{
		Architecture: struct {
			Go     string
			System string
		}{Go: runtime.GOARCH},
	}

	for _, opt := range opts {
		if err := opt(&m); err != nil {
			return &m, err
		}
	}

	return &m, nil
}
