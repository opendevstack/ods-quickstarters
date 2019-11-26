package main

import "testing"

func TestExample(t *testing.T) {
	expected := 1
	actual := 1
	if expected != actual {
		t.Fatalf("Expected: %d, got: %d", expected, actual)
	}
}
