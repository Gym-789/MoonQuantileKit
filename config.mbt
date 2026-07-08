///|
pub(all) struct SummaryConfig {
  max_samples : Int
  tolerated_error_bp : Int
} derive(Eq, Debug)

///|
pub fn SummaryConfig::new(
  max_samples : Int,
  tolerated_error_bp : Int,
) -> SummaryConfig {
  {
    max_samples: if max_samples > 0 { max_samples } else { 1 },
    tolerated_error_bp: clamp_percentile_bp(tolerated_error_bp),
  }
}

///|
pub fn SummaryConfig::default() -> SummaryConfig {
  SummaryConfig::new(2048, 100)
}

///|
pub fn SummaryConfig::exact() -> SummaryConfig {
  SummaryConfig::new(2147483647, 0)
}

///|
pub fn SummaryConfig::is_exact(self : SummaryConfig) -> Bool {
  self.tolerated_error_bp == 0
}
