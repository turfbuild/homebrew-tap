# Turf Homebrew Tap

Homebrew tap for [Turf](https://github.com/turfbuild/turf). Turf™ is a
self-hosted, autonomous infrastructure-as-code tool, built on OpenTofu™. It
deploys the stack an AI factory runs on and keeps it that way, with an agent
overseeing.

```sh
brew install turfbuild/tap/turf
brew services start turf        # this user's Turf engine, now and at every login
```

This installs `turf` (the CLI), `turf-mcp-server`, `turf-engine` and
`turf-builtin-provider`, plus `restate-server` from Restate's own tap, which the
engine runs on. Supported on macOS (Apple Silicon + Intel) and Linux (x86_64 +
arm64). On Linux the CLI is built without CGO, so voice/audio input is inactive;
text chat and all MCP tooling work fully.

## Use it as an MCP server

`turf-mcp-server` is on your `PATH` after install, so you can point any MCP client
at it instead of using the CLI — e.g. register it with Claude Code:

```sh
claude mcp add turf -- turf-mcp-server
```

In Claude Code and Claude Desktop, Turf runs on your Claude subscription (no model
API key). Per-client setup for Codex, Gemini, Cursor, and others is on the
[turfbuild org page](https://github.com/turfbuild#use-it-as-an-mcp-server).

## License

Turf is free for noncommercial use under the PolyForm Noncommercial License
1.0.0. Commercial use, including a company's internal use, needs a license:
https://turf.build/licensing. The `turf` CLI is open source (MPL-2.0). The
formula installs `LICENSE` and `NOTICE` beside the binaries, and `turf license`
prints them. Release notes: https://github.com/turfbuild/turf/releases.

Turf™ is a trademark of Turf LLC. OpenTofu™ is a trademark of The Linux
Foundation. Turf is not affiliated with or endorsed by the Linux Foundation or
the OpenTofu project.
