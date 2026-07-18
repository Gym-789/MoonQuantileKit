///|
fn main {
  let summary = @quantile.SampleSummary::from_array("demo-latency", [
    12, 18, 35, 80, 120, 180, 210, 260, 300, 450,
  ])
  let snapshot = summary.snapshot()
  println("MoonQuantileKit demo")
  println("count: \{snapshot.count}")
  println("p95_ms: \{snapshot.p95_ms}")
  println("p99_ms: \{snapshot.p99_ms}")
  println(snapshot.to_json())
  let bounded = @quantile.BoundedSummary::new(
      "demo-latency",
      @quantile.SummaryConfig::new(8, 1250),
    )
    .add(12)
    .add(18)
    .add(35)
    .add(80)
    .add(120)
    .add(180)
    .add(210)
    .add(260)
    .add(300)
    .add(450)
  println("bounded_centroids: \{bounded.stored_centroids()}")
  println("bounded_p95_ms: \{bounded.p95()}")
}
