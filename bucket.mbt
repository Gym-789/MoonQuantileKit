///|
pub(all) struct LatencyBucket {
  upper_ms : Int
  count : Int
} derive(Eq, Debug)

///|
pub fn LatencyBucket::new(upper_ms : Int) -> LatencyBucket {
  { upper_ms, count: 0 }
}

///|
pub fn bucketize(
  samples : Array[Int],
  boundaries_ms : Array[Int],
) -> Array[LatencyBucket] {
  let buckets : Array[LatencyBucket] = []
  for boundary in boundaries_ms {
    buckets.push(LatencyBucket::new(boundary))
  }
  for sample in samples {
    let mut placed = false
    for index = 0; index < buckets.length(); index = index + 1 {
      if !placed && sample <= buckets[index].upper_ms {
        buckets[index] = LatencyBucket::{
          upper_ms: buckets[index].upper_ms,
          count: buckets[index].count + 1,
        }
        placed = true
      }
    }
  }
  buckets
}

///|
pub fn SampleSummary::buckets(
  self : SampleSummary,
  boundaries_ms : Array[Int],
) -> Array[LatencyBucket] {
  bucketize(self.values, boundaries_ms)
}
