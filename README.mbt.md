# MoonQuantileKit

MoonQuantileKit is a MoonBit foundation library for streaming quantile
estimation and latency summary evaluation. It focuses on small, deterministic
building blocks that can be embedded into benchmarks, service monitors, CLI
tools, and reliability reports.

The initial implementation provides exact and bounded primitives first:

- sorted sample summaries for P50, P90, P95, P99, and custom percentiles
- latency bucket histograms for coarse-grained service dashboards
- snapshot reports with min, max, count, and percentile values
- JSON export helpers for CI logs and monitoring integrations
- a CLI demo and regression tests

## Example

```moonbit nocheck
///|
let summary = SampleSummary::new("checkout").add(12).add(35).add(80)

///|
let p95 = summary.percentile(9500)
```

The public API uses integer milliseconds and basis-point percentiles to avoid
floating-point drift in tests and CI gates.
