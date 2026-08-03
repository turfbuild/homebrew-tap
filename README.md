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

## Use it as an MCP server

`turf-mcp-server` is on your `PATH` after install, so you can point any MCP client
at it instead of using the CLI — e.g. register it with Claude Code:

```sh
claude mcp add turf -- turf-mcp-server
```

In Claude Code and Claude Desktop, Turf runs on your Claude subscription (no model
API key). Per-client setup for Codex, Gemini, Cursor, and others is on the
[turfbuild org page](https://github.com/turfbuild#use-it-as-an-mcp-server).

> Turf is **alpha / pre-release** software. See the
> [release notes](https://github.com/turfbuild/turf/releases) and the licensing
> details on the main repo.
