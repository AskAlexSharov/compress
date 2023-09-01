// Copyright (c) 2021 Klaus Post. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package gzhttp

import (
	"reflect"
	"testing"
)

func assertEqual(tb testing.TB, want, got interface{}) {
	tb.Helper()
	if !reflect.DeepEqual(want, got) {
		tb.Fatalf("want %#v, got %#v", want, got)
	}
}

func assertNotEqual(tb testing.TB, want, got interface{}) {
	tb.Helper()
	if reflect.DeepEqual(want, got) {
		tb.Fatalf("did not want %#v, got %#v", want, got)
	}
}

func assertNil(tb testing.TB, object interface{}) {
	if isNil(object) {
		return
	}
	tb.Helper()
	tb.Fatalf("Expected value to be nil.")
}

func assertNotNil(tb testing.TB, object interface{}) {
	if !isNil(object) {
		return
	}
	tb.Helper()
	tb.Fatalf("Expected value not to be nil.")
}

// isNil checks if a specified object is nil or not, without Failing.
func isNil(object interface{}) bool {
	if object == nil {
		return true
	}

	value := reflect.ValueOf(object)
	kind := value.Kind()
	isNilableKind := containsKind(
		[]reflect.Kind{
			reflect.Chan, reflect.Func,
			reflect.Interface, reflect.Map,
			reflect.Ptr, reflect.Slice},
		kind)

	if isNilableKind && value.IsNil() {
		return true
	}

	return false
}

// containsKind checks if a specified kind in the slice of kinds.
func containsKind(kinds []reflect.Kind, kind reflect.Kind) bool {
	for i := 0; i < len(kinds); i++ {
		if kind == kinds[i] {
			return true
		}
	}

	return false
}
