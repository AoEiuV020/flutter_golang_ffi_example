//go:build cgo

package main

import "C"

//export sum
func sum(a C.int, b C.int) C.int {
	return C.int(Sum(int(a), int(b)))
}

//export enforce_binding
func enforce_binding() {}

func main() {}