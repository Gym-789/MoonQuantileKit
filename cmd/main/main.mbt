///|
fn main {
  let summary = @quantile.SampleSummary::from_array(
    "demo-latency",
    [12, 18, 35, 80, 120, 180, 210, 260, 300, 450],
  )
  let snapshot = summary.snapshot()
  println("MoonQuantileKit demo")
  println("count: \{snapshot.count}")
  println("p95_ms: \{snapshot.p95_ms}")
  println("p99_ms: \{snapshot.p99_ms}")
  println(snapshot.to_json())
}
