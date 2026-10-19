# Turf Homebrew Tap

Homebrew tap for [Turf](https://github.com/turfbuild/turf). Turf™ is a
self-hosted, autonomous infrastructure-as-code tool, built on OpenTofu™. It
deploys the stack an AI factory runs on and keeps it that way, with an agent
overseeing.

```sh
brew install restatedev/tap/restate-server turfbuild/tap/turf
brew services start turf        # this user's Turf engine, now and at every login
```

This installs `turf` (the CLI), `turf-mcp-server`, `turf-engine` and
`turf-builtin-provider`, plus `restate-server` from Restate's own tap, which the
engine runs on. Homebrew loads a formula from a third-party tap only when you
name it, so the command names both; it also upgrades a 0.x install, where
`brew upgrade turf` alone stops at restate-server. Supported on macOS (Apple
Silicon + Intel) and Linux (x86_64 + arm64). On Linux the CLI is built without
CGO, so voice/audio input is inactive; text chat and all MCP tooling work fully.

## Connect your agent

One command registers `turf-mcp-server` with the agents on your machine — Claude
Code, Claude Desktop, Cursor, Codex, Gemini CLI, VS Code and others. It finds the
ones you have, lets you pick, and writes each config with the server's absolute
path, so an app launched from the Dock finds it too (Node 18+;
[add-mcp](https://github.com/neon-solutions/add-mcp) is Neon's open-source
installer):

```sh
npx add-mcp@2 "$(command -v turf-mcp-server)" --name turf -g
```

Without Node, the agent's own command does the same, e.g.
`claude mcp add turf --scope user -- turf-mcp-server`. In Claude Code and Claude
Desktop, Turf runs on your Claude subscription (no model API key). Then, in your
agent: `/turf:guide`. Per-client setup is on the
[turfbuild org page](https://github.com/turfbuild#connect-your-agent).

## The Turf CLI

`turf chat` and `turf up` are Turf's own agent: the same server and engine, driven
by a model you bring (`ANTHROPIC_API_KEY`, a local model, or a private endpoint).
Its README: https://github.com/turfbuild/turf.

## Telemetry

The Turf engine sends anonymous usage telemetry to Turf LLC by default: the
version, the platform, and counts of resources, changes and runs, never their
contents. `turf telemetry off`, then `brew services restart turf`, turns it
off. With Homebrew's analytics off (`brew analytics off` or
`HOMEBREW_NO_ANALYTICS`), the service starts with it off. The field list is at
https://turf.build/telemetry.

## License

Turf is free for noncommercial use under the PolyForm Noncommercial License
1.0.0. Commercial use, including a company's internal use, needs a license:
https://turf.build/licensing. The `turf` CLI is open source (MPL-2.0). The
formula installs `LICENSE` and `NOTICE` beside the binaries, and `turf license`
prints them. Release notes: https://github.com/turfbuild/turf/releases.

Turf™ is a trademark of Turf LLC. OpenTofu™ is a trademark of The Linux
Foundation. Turf is not affiliated with or endorsed by the Linux Foundation or
the OpenTofu project.
