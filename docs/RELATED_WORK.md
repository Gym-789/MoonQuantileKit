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

## Planned approximation direction

The first version intentionally keeps deterministic exact behavior for stable
tests. The public `SummaryConfig` reserves capacity and tolerated-error
settings so later GK-style or t-digest-style bounded summaries can be added
without breaking the API.
