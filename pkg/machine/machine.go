package machine

import (
	"golang.org/x/sys/unix"
	"strings"
)

type What struct {
	Architecture struct {
		Go string
		System string
	} `json:",omitempty"`
}

type Option func(*What) error

// WithUTS returns a Option that indicates that the UTS subsystem should be queried.
func WithUTS() func(*What) error {
	return func(m *What) error {
		uts := unix.Utsname{}
		err := unix.Uname(&uts)
		if err != nil {
			return err
		}
		m.Architecture.System = strings.TrimRight(string(uts.Machine[:]),"\u0000")
		return nil
	}
}
