# Acceptance Notes

Current acceptance surface:

- MoonBit package metadata and readable documentation
- exact sample summary with sorted insertion
- basis-point percentile API
- P50, P90, P95, and P99 snapshot report
- latency bucket histogram
- JSON export helpers
- CLI demo
- regression tests
- GitHub Actions CI

Useful local commands:

```powershell
moon check --target all
moon test --target wasm
moon test --target wasm-gc
moon test --target js
moon run cmd/main
```
