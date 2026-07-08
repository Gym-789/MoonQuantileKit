///|
test "sample summary keeps values sorted" {
  let summary = SampleSummary::new("api").add(80).add(12).add(35)
  assert_eq(summary.count(), 3)
  assert_eq(summary.values[0], 12)
  assert_eq(summary.values[1], 35)
  assert_eq(summary.values[2], 80)
}

///|
test "sample summary reports min and max" {
  let summary = SampleSummary::from_array("worker", [42, 7, 99, 13])
  assert_eq(summary.min(), 7)
  assert_eq(summary.max(), 99)
}

///|
test "percentile helpers use basis points" {
  let summary = SampleSummary::from_array(
    "latency",
    [10, 20, 30, 40, 50, 60, 70, 80, 90, 100],
  )
  assert_eq(summary.p50(), 60)
  assert_eq(summary.p90(), 100)
  assert_eq(summary.percentile(0), 10)
  assert_eq(summary.percentile(10000), 100)
}

///|
test "snapshot exposes common latency percentiles" {
  let snapshot = SampleSummary::from_array("search", [5, 8, 13, 21, 34])
    .snapshot()
  assert_eq(snapshot.name, "search")
  assert_eq(snapshot.count, 5)
  assert_eq(snapshot.min_ms, 5)
  assert_eq(snapshot.max_ms, 34)
  assert_eq(snapshot.p95_ms, 34)
}

///|
test "bucketize assigns samples to first matching boundary" {
  let summary = SampleSummary::from_array("rpc", [3, 7, 12, 30, 80])
  let buckets = summary.buckets([10, 50, 100])
  assert_eq(buckets.length(), 3)
  assert_eq(buckets[0].count, 2)
  assert_eq(buckets[1].count, 2)
  assert_eq(buckets[2].count, 1)
}

///|
test "summary config clamps invalid inputs" {
  let config = SummaryConfig::new(0, 12000)
  assert_eq(config.max_samples, 1)
  assert_eq(config.tolerated_error_bp, 10000)
  assert_true(SummaryConfig::exact().is_exact())
}
