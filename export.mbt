///|
pub fn QuantileSnapshot::to_json(self : QuantileSnapshot) -> String {
  "{\"name\":\"\{escape_json(self.name)}\",\"count\":\{self.count},\"min_ms\":\{self.min_ms},\"max_ms\":\{self.max_ms},\"p50_ms\":\{self.p50_ms},\"p90_ms\":\{self.p90_ms},\"p95_ms\":\{self.p95_ms},\"p99_ms\":\{self.p99_ms}}"
}

///|
pub fn LatencyBucket::to_json(self : LatencyBucket) -> String {
  "{\"upper_ms\":\{self.upper_ms},\"count\":\{self.count}}"
}

///|
fn escape_json(input : String) -> String {
  let buf = StringBuilder(size_hint=input.length() + 8)
  for i = 0; i < input.length(); i = i + 1 {
    let ch = input[i]
    if ch == '"' {
      buf.write_string("\\\"")
    } else if ch == '\\' {
      buf.write_string("\\\\")
    } else {
      buf.write_string(input[i:i + 1].to_owned())
    }
  }
  buf.to_string()
}
