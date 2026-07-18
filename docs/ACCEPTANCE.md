# Acceptance Notes

Current acceptance surface:

- MoonBit package metadata and readable documentation
- exact sample summary with sorted insertion
- bounded weighted-centroid summary with capacity-aware compaction and merge
- basis-point percentile API
- P50, P90, P95, and P99 snapshot report
- latency bucket histogram
- JSON export helpers
- CLI demo
- regression tests
- GitHub Actions CI

Useful local commands:

```powershell
moon fmt --check
moon info && git diff --exit-code -- '*.mbti'
moon check --target all
moon build --target all
moon test --target all
moon run cmd/main
```

`SampleSummary` is the exact baseline and retains all samples. `BoundedSummary`
is the streaming alternative: it respects `SummaryConfig::target_centroids()`,
merges closest adjacent weighted centroids at capacity, and supports bounded
state merge. `tolerated_error_bp` controls the deterministic compression budget;
it is not advertised as a formal probabilistic error guarantee.
