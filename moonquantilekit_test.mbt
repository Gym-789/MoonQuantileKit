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
