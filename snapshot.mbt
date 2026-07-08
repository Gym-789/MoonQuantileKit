///|
pub(all) struct QuantileSnapshot {
  name : String
  count : Int
  min_ms : Int
  max_ms : Int
  p50_ms : Int
  p90_ms : Int
  p95_ms : Int
  p99_ms : Int
} derive(Eq, Debug)

///|
pub fn SampleSummary::snapshot(self : SampleSummary) -> QuantileSnapshot {
  {
    name: self.name,
    count: self.count(),
    min_ms: self.min(),
    max_ms: self.max(),
    p50_ms: self.p50(),
    p90_ms: self.p90(),
    p95_ms: self.p95(),
    p99_ms: self.p99(),
  }
}

///|
pub fn QuantileSnapshot::empty(self : QuantileSnapshot) -> Bool {
  self.count == 0
}
