package xxhash

import (
	"runtime"
	"testing"
	"time"
)

var benchmarks = []struct {
	name string
	n    int64
}{
	{"4B", 4},
	{"100B", 100},
	{"4KB", 4e3},
	{"64KB", 64e3},   // just under maxAsmSize: one call into writeBlocks
	{"128KB", 128e3}, // just over: Write feeds writeBlocks in chunks
	{"10MB", 10e6},
}

func BenchmarkSum64(b *testing.B) {
	for _, bb := range benchmarks {
		in := make([]byte, bb.n)
		for i := range in {
			in[i] = byte(i)
		}
		b.Run(bb.name, func(b *testing.B) {
			b.SetBytes(bb.n)
			for b.Loop() {
				sink = Sum64(in)
			}
		})
	}
}

// BenchmarkDigestBytes covers the path this change touches: Write feeds
// writeBlocks in chunks, so the per-call cost has to stay small.
func BenchmarkDigestBytes(b *testing.B) {
	for _, bb := range benchmarks {
		in := make([]byte, bb.n)
		for i := range in {
			in[i] = byte(i)
		}
		b.Run(bb.name, func(b *testing.B) {
			b.SetBytes(bb.n)
			for b.Loop() {
				var d Digest
				d.Reset()
				d.Write(in)
				sink = d.Sum64()
			}
		})
	}
}

// BenchmarkDigestSTW reports how long a GC took while other work ran alongside
// it. The GC runs on this goroutine and the work on another, so they always
// overlap; a background collector would only sometimes catch the stall.
//
// Each size has a "goloop" case doing the same pass over the same buffer in
// ordinary Go, which is always preemptible. That is the floor: it measures the
// collector's own work, so it says how much of a hash case is the collector
// rather than the stall -- and its error bar says how much of the noise is too.
// Use -benchtime=5s, the collector needs a few thousand cycles to average out.
func BenchmarkDigestSTW(b *testing.B) {
	// gcWaitPerOp collects on this goroutine while work runs on another, and
	// reports the mean wall time of one collection.
	gcWaitPerOp := func(b *testing.B, n int64, work func()) {
		var total time.Duration
		var iters int

		b.SetBytes(n)
		for b.Loop() {
			done := make(chan struct{})
			hashing := make(chan struct{})
			go func() { defer close(done); close(hashing); work() }()
			// Wait until the hash goroutine is running, so the collection below
			// cannot finish before the hash has even started.
			<-hashing
			start := time.Now()
			runtime.GC() // one per iteration, so the mean is well defined
			total += time.Since(start)
			iters++
			<-done
		}
		b.ReportMetric(float64(total.Nanoseconds())/float64(iters), "gcwait-ns/op")
	}

	for _, bb := range []struct {
		name string
		n    int64
	}{{"10MB", 10e6}, {"128MB", 128e6}} {
		// Allocated once, outside b.Run: the closure runs once per -count, and a
		// fresh buffer per run would give each run different sweep work.
		in := make([]byte, bb.n)
		var d Digest

		b.Run(bb.name, func(b *testing.B) {
			gcWaitPerOp(b, bb.n, func() {
				d.Reset()
				d.Write(in)
				sink = d.Sum64()
			})
		})
		b.Run(bb.name+"-goloop", func(b *testing.B) {
			gcWaitPerOp(b, bb.n, func() {
				for _, c := range in {
					sink += uint64(c)
				}
			})
		})
	}
}
