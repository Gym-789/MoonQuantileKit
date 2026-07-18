# MoonQuantileKit

MoonQuantileKit is a zero-dependency MoonBit library for latency percentiles,
bounded streaming summaries, histogram buckets, and machine-readable reports.

`SampleSummary` retains all samples for exact deterministic baselines.
`BoundedSummary` is the streaming alternative: it keeps a configured number of
weighted centroids and supports bounded-state merge.

## Install

```bash
moon add Gym-789/moonquantilekit
```

## Minimal use

```moonbit
import { "Gym-789/moonquantilekit" @quantile }

let config = @quantile.SummaryConfig::new(64, 250)
let summary = @quantile.BoundedSummary::new("checkout", config)
  .add(12)
  .add(35)
  .add(80)
println(summary.p95())
```

## Verify

```bash
moon fmt --check
moon info && git diff --exit-code -- '*.mbti'
moon check --target all
moon build --target all
moon test --target all
moon run cmd/main
```

`tolerated_error_bp` is a deterministic compression-budget control, not a
formal statistical error guarantee. See [README.mbt.md](README.mbt.md) and
[docs/ACCEPTANCE.md](docs/ACCEPTANCE.md) for the API boundary.
