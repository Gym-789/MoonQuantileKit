# Related Work

MoonQuantileKit focuses on streaming quantile summaries for MoonBit service
observability and benchmark reporting.

## Difference from general math packages

General numeric libraries usually provide matrix, vector, statistics, or
formula-oriented utilities. MoonQuantileKit is narrower and more operational:
it models latency samples, percentile snapshots, bucket histograms, and
machine-readable exports for CI and monitoring workflows.

## Difference from charting and data-frame packages

Charting libraries render data, and data-frame libraries organize tabular data.
MoonQuantileKit does not render charts or own a table engine. It produces the
compact quantile values that a chart, report, or alerting system can consume.

## Bounded-summary direction

`BoundedSummary` now provides a deterministic, mergeable weighted-centroid
summary. `SummaryConfig` controls the hard maximum and a compression budget:
smaller tolerated error keeps more centroids, while larger tolerated error
causes earlier compaction. This is intentionally documented as an operational
budget rather than a formal GK or t-digest error bound.
