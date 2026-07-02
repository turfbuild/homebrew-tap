# Turf Homebrew Tap

Homebrew tap for [Turf](https://github.com/turfbuild/turf) — a drop-in replacement
for Terraform with agentic superpowers.

```sh
brew install turfbuild/tap/turf
```

This installs both `turf` (the CLI) and `turf-mcp-server`. Supported on macOS
(Apple Silicon + Intel) and Linux (x86_64 + arm64). On Linux the CLI is built
without CGO, so voice/audio input is inactive; text chat and all MCP tooling
work fully.

> Turf is **alpha / pre-release** software. See the
> [release notes](https://github.com/turfbuild/turf/releases) and the licensing
> details on the main repo.
