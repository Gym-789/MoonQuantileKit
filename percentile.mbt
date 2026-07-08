///|
pub fn clamp_percentile_bp(value : Int) -> Int {
  if value < 0 {
    0
  } else if value > 10000 {
    10000
  } else {
    value
  }
}

///|
pub fn SampleSummary::percentile(
  self : SampleSummary,
  percentile_bp : Int,
) -> Int {
  let count = self.count()
  if count == 0 {
    0
  } else if count == 1 {
    self.values[0]
  } else {
    let bp = clamp_percentile_bp(percentile_bp)
    let rank = ((count - 1) * bp + 9999) / 10000
    self.values[rank]
  }
}

///|
pub fn SampleSummary::p50(self : SampleSummary) -> Int {
  self.percentile(5000)
}

///|
pub fn SampleSummary::p90(self : SampleSummary) -> Int {
  self.percentile(9000)
}

///|
pub fn SampleSummary::p95(self : SampleSummary) -> Int {
  self.percentile(9500)
}

///|
pub fn SampleSummary::p99(self : SampleSummary) -> Int {
  self.percentile(9900)
}
