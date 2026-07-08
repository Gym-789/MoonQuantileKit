///|
pub(all) struct SampleSummary {
  name : String
  values : Array[Int]
} derive(Eq, Debug)

///|
pub fn SampleSummary::new(name : String) -> SampleSummary {
  { name, values: [] }
}

///|
pub fn SampleSummary::from_array(
  name : String,
  samples : Array[Int],
) -> SampleSummary {
  let summary = SampleSummary::new(name)
  for sample in samples {
    summary.add(sample) |> ignore
  }
  summary
}

///|
pub fn SampleSummary::add(
  self : SampleSummary,
  value : Int,
) -> SampleSummary {
  let mut inserted = false
  let output : Array[Int] = []
  for current in self.values {
    if not(inserted) && value <= current {
      output.push(value)
      inserted = true
    }
    output.push(current)
  }
  if not(inserted) {
    output.push(value)
  }
  { name: self.name, values: output }
}

///|
pub fn SampleSummary::count(self : SampleSummary) -> Int {
  self.values.length()
}

///|
pub fn SampleSummary::is_empty(self : SampleSummary) -> Bool {
  self.count() == 0
}

///|
pub fn SampleSummary::min(self : SampleSummary) -> Int {
  if self.is_empty() {
    0
  } else {
    self.values[0]
  }
}

///|
pub fn SampleSummary::max(self : SampleSummary) -> Int {
  let count = self.count()
  if count == 0 {
    0
  } else {
    self.values[count - 1]
  }
}
