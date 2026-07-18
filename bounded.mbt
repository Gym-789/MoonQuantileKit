/// A weighted representative retained by a bounded streaming summary.

///|
pub(all) struct QuantileCentroid {
  mean_ms : Int
  count : Int
} derive(Eq, Debug)

/// A deterministic, bounded-memory quantile summary. It merges the closest
/// adjacent centroids whenever the configuration's target capacity is reached.
/// The summary is appropriate for monitoring and benchmark reports where a
/// bounded approximation is preferable to retaining every latency sample.

///|
pub(all) struct BoundedSummary {
  name : String
  config : SummaryConfig
  centroids : Array[QuantileCentroid]
  sample_count : Int
} derive(Eq, Debug)

///|
pub fn BoundedSummary::new(
  name : String,
  config : SummaryConfig,
) -> BoundedSummary {
  { name, config, centroids: [], sample_count: 0 }
}

///|
pub fn BoundedSummary::count(self : BoundedSummary) -> Int {
  self.sample_count
}

///|
pub fn BoundedSummary::stored_centroids(self : BoundedSummary) -> Int {
  self.centroids.length()
}

///|
pub fn BoundedSummary::capacity(self : BoundedSummary) -> Int {
  self.config.target_centroids()
}

///|
fn insert_centroid_sorted(
  centroids : Array[QuantileCentroid],
  incoming : QuantileCentroid,
) -> Array[QuantileCentroid] {
  let output = []
  let mut inserted = false
  for centroid in centroids {
    if !inserted && incoming.mean_ms <= centroid.mean_ms {
      output.push(incoming)
      inserted = true
    }
    output.push(centroid)
  }
  if !inserted {
    output.push(incoming)
  }
  output
}

///|
fn closest_pair_index(centroids : Array[QuantileCentroid]) -> Int {
  let mut best_index = 0
  let mut best_distance = centroids[1].mean_ms - centroids[0].mean_ms
  for index = 1; index + 1 < centroids.length(); index = index + 1 {
    let distance = centroids[index + 1].mean_ms - centroids[index].mean_ms
    if distance < best_distance {
      best_distance = distance
      best_index = index
    }
  }
  best_index
}

///|
fn merge_pair(
  centroids : Array[QuantileCentroid],
  index : Int,
) -> Array[QuantileCentroid] {
  let output = []
  let left = centroids[index]
  let right = centroids[index + 1]
  let total = left.count + right.count
  let merged = {
    mean_ms: (left.mean_ms * left.count + right.mean_ms * right.count) / total,
    count: total,
  }
  for current = 0; current < centroids.length(); current = current + 1 {
    if current == index {
      output.push(merged)
    } else if current != index + 1 {
      output.push(centroids[current])
    }
  }
  output
}

///|
fn compact_to_capacity(
  centroids : Array[QuantileCentroid],
  capacity : Int,
) -> Array[QuantileCentroid] {
  let mut compacted = centroids
  while compacted.length() > capacity {
    compacted = merge_pair(compacted, closest_pair_index(compacted))
  }
  compacted
}

/// Adds one sample and compacts deterministically when the configured budget
/// is exceeded.

///|
pub fn BoundedSummary::add(
  self : BoundedSummary,
  value_ms : Int,
) -> BoundedSummary {
  {
    name: self.name,
    config: self.config,
    centroids: compact_to_capacity(
      insert_centroid_sorted(self.centroids, { mean_ms: value_ms, count: 1 }),
      self.capacity(),
    ),
    sample_count: self.sample_count + 1,
  }
}

/// Merges another summary without expanding it into individual samples.
/// The receiver's configuration controls the resulting memory bound.

///|
pub fn BoundedSummary::merge(
  self : BoundedSummary,
  other : BoundedSummary,
) -> BoundedSummary {
  let mut centroids = self.centroids
  for centroid in other.centroids {
    centroids = compact_to_capacity(
      insert_centroid_sorted(centroids, centroid),
      self.capacity(),
    )
  }
  {
    name: self.name,
    config: self.config,
    centroids,
    sample_count: self.sample_count + other.sample_count,
  }
}

/// Returns a weighted-centroid approximation at the requested basis-point
/// percentile. Empty summaries return zero, matching `SampleSummary`.

///|
pub fn BoundedSummary::percentile(
  self : BoundedSummary,
  percentile_bp : Int,
) -> Int {
  if self.sample_count == 0 {
    return 0
  }
  let target_rank = (
      (self.sample_count - 1) * clamp_percentile_bp(percentile_bp) + 9999
    ) /
    10000
  let mut seen = 0
  for centroid in self.centroids {
    seen = seen + centroid.count
    if target_rank < seen {
      return centroid.mean_ms
    }
  }
  self.centroids[self.centroids.length() - 1].mean_ms
}

///|
pub fn BoundedSummary::p95(self : BoundedSummary) -> Int {
  self.percentile(9500)
}
