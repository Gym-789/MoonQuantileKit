///|
fn main {
  let summary = @quantile.SampleSummary::from_array(
    "demo-latency",
    [12, 18, 35, 80, 120],
  )
  println("MoonQuantileKit demo")
  println("count: \{summary.count()}")
  println("min_ms: \{summary.min()}")
  println("max_ms: \{summary.max()}")
}
